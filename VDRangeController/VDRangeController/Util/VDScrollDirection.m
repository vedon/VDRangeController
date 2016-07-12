//
//  VDScrollDirection.m
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDScrollDirection.h"

BOOL VDScrollDirectionContainersUp(VDScrollDirection direction)
{
    return (direction & VDScrollDirectionUp) != 0;
}
BOOL VDScrollDirectionContainersDown(VDScrollDirection direction)
{
    return (direction & VDScrollDirectionDown) != 0;
}

BOOL VDScrollDirectionContainersHor(VDScrollDirection direction)
{
    return (direction & VDScrollDirectionHor) != 0;
}

BOOL VDScrollDirectionContainersVer(VDScrollDirection direction)
{
    return (direction & VDScrollDirectionVer) != 0;
}