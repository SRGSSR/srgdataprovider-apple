//
//  Copyright (c) RTS. All rights reserved.
//
//  Licence information is available from the LICENCE file.
//

#import "RTSAnalyticsVersion_private.h"

NSString * const RTSAnalyticsVersion(void)
{
    // TODO: Can be replaced by a bundle version when a resource bundle is available. Do not forget to remove the preprocessor
    //       definition associated with this file in the podspec
#ifdef RTS_ANALYTICS_VERSION
    return @(OS_STRINGIFY(RTS_ANALYTICS_VERSION));
#else
    #warning No explicit version has been specified, set to "dev". Compile the project with a preprocessor macro called RTS_ANALYTICS_VERSION supplying the version number (without quotes)
    return @"dev";
#endif
}
