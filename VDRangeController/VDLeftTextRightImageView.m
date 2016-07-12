//
//  VDLeftTextRightImageView.m
//  VDRangeController
//
//  Created by vedon on 8/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//


#import "VDLeftTextRightImageView.h"
#import "VDData.h"
#import "VDLeftTextRightImageLayout.h"
#import "VDEdgeInsets.h"
#import "UIViewAdditionsExt.h"

@interface VDLeftTextRightImageView ()
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIImageView *descImageView;
@property (strong,nonatomic) VDLeftTextRightImageLayout *layout;
@end


@implementation VDLeftTextRightImageView

- (instancetype)initWithFrame:(CGRect)frame layout:(VDLeftTextRightImageLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layout = layout;
        [self addSubview:self.descLabel];
        [self addSubview:self.descImageView];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageViewSize = [self.layout imageViewSize];
    UIEdgeInsets imageViewInsets = [self.layout imageViewInsets];
    CGRect imageViewRect = CGRectMake(self.width - imageViewSize.width  - imageViewInsets.right,
                                      (self.height - imageViewSize.width + VDVerticalHeightOfInsets(imageViewInsets))/2,
                                      imageViewSize.width,
                                      imageViewSize.height);
    self.descImageView.frame = imageViewRect;
    [self.descImageView pixelAligned];
    
    
    
    UIEdgeInsets descLabelInsets = [self.layout descLabelInsets];
    CGRect descLabelRect = VDAutoFillRectZeroWithInsets(descLabelInsets);
    descLabelRect.size = CGSizeMake(self.width - imageViewSize.width - VDLeftToRightPaddingOfInsets(descLabelInsets,imageViewInsets),self.height - VDVerticalHeightOfInsets(descLabelInsets));
    self.descLabel.frame = descLabelRect;
    [self.descLabel pixelAligned];
    
    
}

- (void)configureWithData:(VDData *)data
{
    self.descLabel.text = [data title];
    self.descImageView.image = [data image];
}

#pragma mark - Getter & Setter

- (UILabel *)descLabel
{
    if (!_descLabel)
    {
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 20;
        _descLabel.font = [self.layout descLabelFont];
    }
    return _descLabel;
}

- (UIImageView *)descImageView
{
    if (!_descImageView)
    {
        _descImageView = [[UIImageView alloc] init];
    }
    return _descImageView;
}

@end
