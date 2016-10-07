//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRequest.h"

#import "NSBundle+SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGDataProviderLogger.h"
#import "SRGPage+Private.h"
#import "SRGRequest+Private.h"

#import <libextobjc/libextobjc.h>
#import <UIKit/UIKit.h>

static NSInteger s_numberOfRunningRequests = 0;

@interface SRGRequest ()

@property (nonatomic) NSURLRequest *request;
@property (nonatomic) SRGPage *page;
@property (nonatomic, copy) SRGRequestCompletionBlock completionBlock;

@property (nonatomic) NSURLSessionTask *sessionTask;
@property (nonatomic, weak) NSURLSession *session;

@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation SRGRequest

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request page:(SRGPage *)page session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock
{
    if (self = [super init]) {
        self.request = request;
        self.completionBlock = completionBlock;
        self.page = page ?: [SRGPage firstPageWithDefaultSize];
        self.session = session;
        self.managingNetworkActivityIndicator = YES;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock
{
    return [self initWithRequest:request page:nil session:session completionBlock:completionBlock];
}

#pragma mark Getters and setters

- (void)setManagingNetworkActivityIndicator:(BOOL)managingNetworkActivityIndicator
{
    if (self.running) {
        return;
    }
    
    _managingNetworkActivityIndicator = managingNetworkActivityIndicator;
}

- (void)setRunning:(BOOL)running
{
    if (running != _running && self.managingNetworkActivityIndicator) {
        if (running) {
            if (s_numberOfRunningRequests == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
            ++s_numberOfRunningRequests;
        }
        else {
            --s_numberOfRunningRequests;
            if (s_numberOfRunningRequests == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
    }
    
    _running = running;
}

#pragma mark Session task management

- (void)resume
{
    if (self.running) {
        return;
    }
    
    void (^requestCompletionBlock)(NSDictionary * _Nullable, SRGPage * _Nullable, NSError * _Nullable) = ^(NSDictionary * _Nullable JSONDictionary, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completionBlock(JSONDictionary, self.page, nextPage, error);
            self.running = NO;
        });
    };
    
    SRGDataProviderLogDebug(@"Request", @"Started %@ with page %@", self.request.URL, self.page);
    
    // Session tasks cannot be reused. To provide SRGRequest reuse, we need to instantiate another task
    @weakify(self)
    self.sessionTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self)
        
        // Don't call the completion block for cancelled requests
        if (error) {
            if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
                SRGDataProviderLogDebug(@"Request", @"Cancelled %@", self.request.URL);
            }
            else {
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with an error: %@", self.request.URL, error);
                requestCompletionBlock(nil, nil, error);
            }
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            NSInteger HTTPStatusCode = HTTPURLResponse.statusCode;
            
            // Properly handle HTTP error codes >= 400 as real errors
            if (HTTPStatusCode >= 400) {
                NSError *HTTPError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorHTTP
                                                     userInfo:@{ NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:HTTPStatusCode],
                                                                 NSURLErrorKey : response.URL }];
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with an HTTP error: %@", self.request.URL, HTTPError);
                requestCompletionBlock(nil, nil, HTTPError);
                return;
            }
            // Block redirects and return an error with URL information. Currently no redirection is expected for IL services, this
            // means redirection is probably related to a public hotspot with login page (e.g. SBB)
            else if (HTTPStatusCode >= 300) {
                NSMutableDictionary *userInfo = [@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"You are likely connected to a public wifi network with no Internet access", nil),
                                                    NSURLErrorKey : response.URL } mutableCopy];
                
                NSString *redirectionURLString = HTTPURLResponse.allHeaderFields[@"Location"];
                if (redirectionURLString) {
                    NSURL *redirectionURL = [NSURL URLWithString:redirectionURLString];
                    userInfo[SRGDataProviderRedirectionURLKey] = redirectionURL;
                }
                
                NSError *redirectError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                             code:SRGDataProviderErrorRedirect
                                                         userInfo:[userInfo copy]];
                SRGDataProviderLogDebug(@"Request", @"Ended %@ with a redirect error: %@", self.request.URL, redirectError);
                requestCompletionBlock(nil, nil, redirectError);
                return;
            }
        }
        
        id JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (!JSONDictionary || ![JSONDictionary isKindOfClass:[NSDictionary class]]) {
            NSError *dataFormatError = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                           code:SRGDataProviderErrorCodeInvalidData
                                                       userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }];
            SRGDataProviderLogDebug(@"Request", @"Ended %@ with a data format error: %@", self.request.URL, dataFormatError);
            requestCompletionBlock(nil, nil, dataFormatError);
            return;
        }
        
        NSString *nextPath = JSONDictionary[@"next"];
        
#warning Next links will be updated server-side. Until then, no next pages
        SRGPage *nextPage = nil;
        // SRGPage *nextPage = nextPath ? [self.page nextPageWithPath:nextPath] : nil;
        
        SRGDataProviderLogDebug(@"Request", @"Ended %@ successfully with JSON %@ and next page %@", self.request.URL, JSONDictionary, nextPage);
        requestCompletionBlock(JSONDictionary, nextPage, nil);
    }];
    
    self.running = YES;
    [self.sessionTask resume];
}

- (void)cancel
{
    self.running = NO;
    [self.sessionTask cancel];
}

#pragma mark Page management

- (SRGRequest *)withPageSize:(NSInteger)pageSize
{
    SRGPage *page = [SRGPage firstPageWithSize:pageSize];
    return [self atPage:page];
}

- (SRGRequest *)atPage:(nullable SRGPage *)page
{
    NSURLRequest *request = [SRGPage request:self.request withPage:page];
    return [[[self class] alloc] initWithRequest:request page:page session:self.session completionBlock:self.completionBlock];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; request: %@; running: %@>",
            [self class],
            self,
            self.request,
            self.running ? @"YES" : @"NO"];
}

@end