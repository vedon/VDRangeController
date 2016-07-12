//
//  VDLeftTextRightImageView.h
//  VDRangeController
//
//  Created by vedon on 8/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDLeftTextRightImageLayout;
@class VDData;

@interface VDLeftTextRightImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame layout:(VDLeftTextRightImageLayout *)layout;

- (void)configureWithData:(VDData *)data;


@end
