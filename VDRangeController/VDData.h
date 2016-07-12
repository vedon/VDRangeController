//
//  VDData.h
//  VDRangeController
//
//  Created by vedon on 9/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDDataProtocol.h"

@class UIView;
@class UIImage;
@interface VDData : NSObject<VDDataProtocol>

@property (copy,nonatomic) NSString *title;
@property (assign,nonatomic) NSUInteger index;
@property (strong,nonatomic) UIImage *image;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                        index:(NSUInteger)index;


@end
