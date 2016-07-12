//
//  VDEdgeInsets.h
//  VDRangeController
//
//  Created by vedon on 7/11/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDBaseDefine.h"

EXTERN_C_BEGIN

CGFloat VDVerticalHeightOfInsets(UIEdgeInsets insets);

CGFloat VDHorizonWidthOfInsets(UIEdgeInsets insets);

CGFloat VDLeftToRightPaddingOfInsets(UIEdgeInsets firInsets,UIEdgeInsets secInsets);

CGFloat VDTopToBottomPaddingOfInsets(UIEdgeInsets firInsets,UIEdgeInsets secInsets);

CGRect VDAutoFillRectZeroWithInsets(UIEdgeInsets insets);

EXTERN_C_END
