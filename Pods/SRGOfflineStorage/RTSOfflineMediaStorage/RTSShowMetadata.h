//
//  RTSShowMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Realm/Realm.h>
#import "RTSBaseMetadata.h"
#import "RTSMetadatasProtocols.h"

@interface RTSShowMetadata : RTSBaseMetadata <RTSShowMetadataContainer>

@property NSString *showDescription;

@end

RLM_ARRAY_TYPE(RTSShowMetadata)
