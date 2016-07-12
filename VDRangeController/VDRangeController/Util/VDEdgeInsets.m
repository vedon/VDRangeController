//
//  VDEdgeInsets.m
//  VDRangeController
//
//  Created by vedon on 7/11/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDEdgeInsets.h"

CGFloat VDVerticalHeightOfInsets(UIEdgeInsets insets)
{
    return insets.top + insets.bottom;
}

CGFloat VDHorizonWidthOfInsets(UIEdgeInsets insets)
{
    return insets.left + insets.right;
}

CGFloat VDLeftToRightPaddingOfInsets(UIEdgeInsets firInsets,UIEdgeInsets secInsets)
{
    return firInsets.left + secInsets.right;
}

CGFloat VDTopToBottomPaddingOfInsets(UIEdgeInsets firInsets,UIEdgeInsets secInsets)
{
    return firInsets.top + secInsets.bottom;
}

CGRect VDAutoFillRectZeroWithInsets(UIEdgeInsets insets)
{
    return CGRectMake(insets.top, insets.left, 0, 0);
}