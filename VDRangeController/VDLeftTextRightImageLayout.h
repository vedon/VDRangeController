//
//  VDLeftTextRightImageLayoutAttribute.h
//  VDRangeController
//
//  Created by vedon on 10/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDLeftTextRightImageLayout : NSObject

@property (assign,nonatomic) UIEdgeInsets descLabelInsets;
@property (assign,nonatomic) UIEdgeInsets imageViewInsets;
@property (assign,nonatomic) CGSize       imageViewSize;
@property (strong,nonatomic) UIFont       *descLabelFont;

- (CGSize)layoutSizeWithTitle:(NSString *)title contrainToSize:(CGSize)contraintSize;

@end
