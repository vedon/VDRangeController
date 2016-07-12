//
//  VDLeftTextRightImageLayoutAttribute.m
//  VDRangeController
//
//  Created by vedon on 10/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDLeftTextRightImageLayout.h"
#import "VDEdgeInsets.h"

@implementation VDLeftTextRightImageLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.descLabelInsets = UIEdgeInsetsMake(10,10,10,10);
        self.imageViewInsets = UIEdgeInsetsMake(10,10,10,10);
        self.imageViewSize = CGSizeMake(40, 40);
        self.descLabelFont = [UIFont systemFontOfSize:18];
    }
    return self;
}

- (CGSize)layoutSizeWithTitle:(NSString *)title contrainToSize:(CGSize)contraintSize
{
    CGSize size = contraintSize;
    if (title)
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : [self descLabelFont],
                                     NSParagraphStyleAttributeName: paragraph};
        
        CGFloat width = contraintSize.width - self.imageViewSize.width - VDHorizonWidthOfInsets(self.descLabelInsets) - VDHorizonWidthOfInsets(self.imageViewInsets);
        
        CGRect stringRect = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:attributes
                                                context:nil];
        
        size.height = stringRect.size.height;
        UIEdgeInsets descLabelInsets = [self descLabelInsets];
        
        size.height += VDVerticalHeightOfInsets(descLabelInsets);
    }
    return size;
}

@end
