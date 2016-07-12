//
//  VDData.m
//  VDRangeController
//
//  Created by vedon on 9/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDData.h"
#import "LeftTextRightImageDisplayItem.h"

@interface VDData ()
@property (strong,nonatomic) LeftTextRightImageDisplayItem *displayItem;

@end

@implementation VDData

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                        index:(NSUInteger)index
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.index = index;
        self.image = image;
        
        self.displayItem = [[LeftTextRightImageDisplayItem alloc] init];
        [self.displayItem configureWithData:self];
    }
    return self;
}

- (VDDisplayItem *)displayItem
{
    return _displayItem;
}

@end
