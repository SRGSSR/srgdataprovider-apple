//
//  RTSBaseMetadata.m
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import "RTSBaseMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))
#define REALM_NONNULL_DATE(value) ((value == nil) ? [NSDate dateWithTimeIntervalSince1970:0] : (value))

@implementation RTSBaseMetadata

+ (NSString *)primaryKey
{
    return @"identifier";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"identifier": @"",
             @"title": @"",
             @"imageURLString": @"",
             @"expirationDate": [NSDate dateWithTimeIntervalSince1970:0],
             @"favoriteChangeDate": [NSDate dateWithTimeIntervalSince1970:0],
             @"isFavorite": @(0)};
}

+ (instancetype)metadataForContainer:(id<RTSBaseMetadataContainer>)container
{
    if (!container) {
        return nil;
    }
    
    RTSBaseMetadata *md = [[self alloc] initWithContainer:container];
    return md;
    
}

- (instancetype)initWithContainer:(id<RTSBaseMetadataContainer>)container
{
    if (!container) {
        return nil;
    }

    self = [super init];
    if (self) {
        self.identifier = REALM_NONNULL_STRING([container identifier]);
        self.title = REALM_NONNULL_STRING([container title]);
        self.imageURLString = REALM_NONNULL_STRING([container imageURLString]);
        self.audioChannelID = REALM_NONNULL_STRING([container audioChannelID]);

        self.expirationDate = REALM_NONNULL_DATE([container expirationDate]);
        self.favoriteChangeDate = REALM_NONNULL_DATE(nil);
        
        self.isFavorite = [container isFavorite];
    }
    return self;
}

- (BOOL)isValueEmptyForKey:(NSString *)key
{
    NSArray *propertyKeys = [[[self class] defaultPropertyValues] allKeys];
    if (![propertyKeys containsObject:key]) {
        return NO;
    }
    return [[self valueForKey:key] isEqual:[[[self class] defaultPropertyValues] objectForKey:key]];
}

@end
