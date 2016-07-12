//
//  VDScrollDirection.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDBaseDefine.h"

typedef NS_OPTIONS(NSInteger, VDScrollDirection) {
    VDScrollDirectionNone  = 0,
    VDScrollDirectionUp    = 1 << 1,
    VDScrollDirectionDown  = 1 << 2,
    VDScrollDirectionLeft  = 1 << 3,
    VDScrollDirectionRight = 1 << 4,
    VDScrollDirectionHor   = 1 << 5,
    VDScrollDirectionVer   = 1 << 6,
};


//Objective-C is slightly slower than straight C function calls because of the lookups involved in its dynamic nature. I'll edit this answer with more detail on how it works later if nobody else adds in the detail.
// The reason 👉 (http://www.xs-labs.com/en/blog/2012/01/16/mixing-cpp-objective-c/)
EXTERN_C_BEGIN

/**
 *  <#Description#>
 *
 *  @param direction <#direction description#>
 *
 *  @return <#return value description#>
 */
BOOL VDScrollDirectionContainersUp(VDScrollDirection direction);

/**
 *  <#Description#>
 *
 *  @param direction <#direction description#>
 *
 *  @return <#return value description#>
 */
BOOL VDScrollDirectionContainersDown(VDScrollDirection direction);


/**
 *  <#Description#>
 *
 *  @param direction <#direction description#>
 *
 *  @return <#return value description#>
 */
BOOL VDScrollDirectionContainersHor(VDScrollDirection direction);

/**
 *  <#Description#>
 *
 *  @param direction <#direction description#>
 *
 *  @return <#return value description#>
 */
BOOL VDScrollDirectionContainersVer(VDScrollDirection direction);

EXTERN_C_END