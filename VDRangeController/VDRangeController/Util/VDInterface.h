//
//  VDInterface.h
//  VDRangeController
//
//  Created by vedon on 7/4/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDBaseDefine.h"

typedef NS_OPTIONS(NSUInteger,VDInterfaceState)
{
    VDInterfaceState_Initialize = 0,
    VDInterfaceState_Visible = 1<<0,
    VDInterfaceState_Display = 1<<1,
    VDInterfaceState_MeasureLayout = 1<<2,
    VDInterfaceState_FetchData = 1<<3,
};


EXTERN_C_BEGIN

//inline error : http://stackoverflow.com/questions/10243018/inline-function-undefined-symbols-error

/**
 *  <#Description#>
 *
 *  @param interfaceState <#interfaceState description#>
 *
 *  @return <#return value description#>
 */
static inline BOOL VDInterfaceStateIncludesVisible(VDInterfaceState interfaceState)
{
    return ((interfaceState & VDInterfaceState_Visible) == VDInterfaceState_Visible);
}

/**
 *  <#Description#>
 *
 *  @param interfaceState <#interfaceState description#>
 *
 *  @return <#return value description#>
 */
static inline BOOL VDInterfaceStateIncludesDisplay(VDInterfaceState interfaceState)
{
    return ((interfaceState & VDInterfaceState_Display) == VDInterfaceState_Display);
}

/**
 *  <#Description#>
 *
 *  @param interfaceState <#interfaceState description#>
 *
 *  @return <#return value description#>
 */
static inline BOOL VDInterfaceStateIncludesMeasureLayout(VDInterfaceState interfaceState)
{
    return ((interfaceState & VDInterfaceState_MeasureLayout) == VDInterfaceState_MeasureLayout);
}

/**
 *  <#Description#>
 *
 *  @param interfaceState <#interfaceState description#>
 *
 *  @return <#return value description#>
 */
static inline BOOL VDInterfaceStateIncludesFetchData(VDInterfaceState interfaceState)
{
    return ((interfaceState & VDInterfaceState_FetchData) == VDInterfaceState_FetchData);
}

EXTERN_C_END


