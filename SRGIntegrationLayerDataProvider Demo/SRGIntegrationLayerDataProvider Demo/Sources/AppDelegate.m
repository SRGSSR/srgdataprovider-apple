//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGAnalytics/SRGAnalytics.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    self.dataSource = [[SRGILDataProvider alloc] initWithBusinessUnit:@"rts"];

    [[RTSAnalyticsTracker sharedTracker] setComscoreVSite:@"rts-app-test-v"];
    [[RTSAnalyticsTracker sharedTracker] setNetmetrixAppId:@"test"];
    [[RTSAnalyticsTracker sharedTracker] setProduction:NO];

    [[RTSAnalyticsTracker sharedTracker] startTrackingForBusinessUnit:SSRBusinessUnitRTS
                                                      mediaDataSource:self.dataSource];
        
    return YES;
}

@end
