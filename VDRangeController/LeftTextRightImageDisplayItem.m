//
//  DataItem.m
//  VDRangeController
//
//  Created by vedon on 7/6/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "LeftTextRightImageDisplayItem.h"
#import "VDLeftTextRightImageView.h"
#import "VDLeftTextRightImageLayout.h"
#import "VDData.h"
#import "VDLeftTextRightImageLayout.h"

@interface LeftTextRightImageDisplayItem ()
@property (strong,nonatomic) VDData *displayItemData;
@property (strong,nonatomic) VDLeftTextRightImageLayout *layout;
@end

@implementation LeftTextRightImageDisplayItem

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.displayItemPlaceholderHeight = 60;
        self.layout = [[VDLeftTextRightImageLayout alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        [self configureWithDisplay:^(id<VDDisplayItemProtocol> displayItem) {
            
            [weakSelf configureContentView];
            
        } measureLayout:^(id<VDDisplayItemProtocol> displayItem) {
        
            return [weakSelf layoutSize];
            
        } fetchData:^(id<VDDisplayItemProtocol> displayItem) {
            
            
        }];
    }
    return  self;
}

 - (NSString *)description
{
    return [NSString stringWithFormat:@"Item %lu",(unsigned long)[self.displayItemData index]];
}

#pragma mark - Override

- (UIView *)displayView
{
    return [[VDLeftTextRightImageView alloc] initWithFrame:CGRectMake(0, 0, self.displayContentWidth, self.displayContentHeight) layout:self.layout];
}

- (NSString *)resueDisplayViewIdentifier
{
    return @"VDLeftTextRightImageView";
}

- (void)configureWithData:(id)displayItemData
{
    self.displayItemData = displayItemData;
}

#pragma mark - Private

- (CGSize)layoutSize
{
    return [self.layout layoutSizeWithTitle:self.displayItemData.title contrainToSize:CGSizeMake(self.displayContentWidth, CGFLOAT_MAX)];
}

- (void)configureContentView
{
    VDLeftTextRightImageView *tempView = (VDLeftTextRightImageView *)self.displayContentView;
    [tempView configureWithData:self.displayItemData];
}

@end
