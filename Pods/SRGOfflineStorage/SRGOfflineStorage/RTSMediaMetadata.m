//
//  SRGILMediaMetadata.m
//  SRGOfflineStorage
//
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "RTSMediaMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))
#define REALM_NONNULL_DATE(value) ((value == nil) ? [NSDate dateWithTimeIntervalSince1970:0] : (value))

@implementation RTSMediaMetadata

+ (NSString *)primaryKey
{
    return @"identifier";
}

+ (NSDictionary *)defaultPropertyValues
{
    NSMutableDictionary *defaults = [[[self superclass] defaultPropertyValues] mutableCopy];
    defaults[@"parentTitle"] = @"";
    defaults[@"mediaDescription"] = @"";
    defaults[@"audioChannelID"] = @"";
    defaults[@"publicationDate"] = [NSDate dateWithTimeIntervalSince1970:0];
    defaults[@"type"] = @(0);
    defaults[@"durationInMs"] = @(-1);
    defaults[@"viewCount"] = @(-1);
    defaults[@"isDownloadable"] = @(0);
    defaults[@"isDownloading"] = @(0);
    defaults[@"isDownloaded"] = @(0);
    defaults[@"downloadURLString"] = @"";
    defaults[@"localURLString"] = @"";
    return [defaults copy];
}

- (instancetype)initWithContainer:(id<SRGMediaMetadataContainer>)container
{
    self = [super initWithContainer:container];
    if (self) {
        [self udpateWithContainer:container];
    }
    return self;
}

- (void)udpateWithContainer:(id<SRGMediaMetadataContainer>)container
{
    [super udpateWithContainer:container];
    self.parentTitle = REALM_NONNULL_STRING([container parentTitle]);
    self.mediaDescription = REALM_NONNULL_STRING([container mediaDescription]);
    
    self.publicationDate = REALM_NONNULL_DATE([container publicationDate]);
    
    self.type = [container type];
    self.durationInMs = [container durationInMs];
    self.viewCount = [container viewCount];
    self.isDownloadable = [container isDownloadable];
    
    self.isDownloading = [container isDownloading];
    self.isDownloaded = [container isDownloaded];
    
    self.downloadURLString = REALM_NONNULL_STRING([container downloadURLString]);
    self.localURLString = REALM_NONNULL_STRING([container localURLString]);
}

@end
