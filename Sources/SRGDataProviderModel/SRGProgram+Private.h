//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGProgram.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This function takes a list of programs as input, and sanitizes it so that programs do not
 *  overlap and cover the associated time range without gaps. Subprograms are taken into account
 *  as well.
 */
OBJC_EXPORT NSArray<SRGProgram *> * _Nullable SRGSanitizedPrograms(NSArray<SRGProgram *> * _Nullable programs);

NS_ASSUME_NONNULL_END
