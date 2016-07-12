//
//  VDLayoutController.m
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDLayoutController.h"
#import "VDAssert.h"
#import "VDIndexPath.h"
#import "VDDisplayItem.h"

@interface VDLayoutController ()
{
    struct VDLayoutControllerFlag
    {
        unsigned didLoadItems:1;
        unsigned itemAtIndexPath:1;
    }_flags;
}

@property (assign,nonatomic) VDScrollDirection _layoutDirection;
@property (assign,nonatomic) VDIndexPathRange _visibleRange;
@property (assign,nonatomic) CGFloat _factor;
@property (assign,nonatomic) CGSize _viewSize;
@end

@implementation VDLayoutController

- (instancetype)initWithLayoutDirection:(VDScrollDirection)layoutDirection
                               viewSize:(CGSize)viewSize
                                 factor:(CGFloat)factor
                               delegate:(id<VDLayoutControllerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self._layoutDirection = layoutDirection;
        self._factor = factor;
        self.delegate = delegate;
        self._viewSize = viewSize;
    }
    return self;
}

#pragma mark - Public

- (NSSet <NSIndexPath *> *)indexPathsForScrollDirection:(VDScrollDirection)scrollDirection rangeType:(VDRangeType)rangeType
{
    
    CGFloat contentViewSize = 0;
    if (__layoutDirection == VDScrollDirectionHor) {
        VDAssert(scrollDirection == VDScrollDirectionNone ||
                 scrollDirection == VDScrollDirectionLeft ||
                 scrollDirection == VDScrollDirectionRight, @"Invalid scroll direction");
        
        contentViewSize = self._viewSize.width;
    } else {
        VDAssert(scrollDirection == VDScrollDirectionNone ||
                 scrollDirection == VDScrollDirectionUp   ||
                 scrollDirection == VDScrollDirectionDown, @"Invalid scroll direction");
        
        contentViewSize = self._viewSize.height;
    }
    
    CGFloat distanceToTop = -([self distanceWithViewSize:contentViewSize forRangeType:rangeType]);
    CGFloat distanceFromBottom = -distanceToTop;
    
    VDIndexPath startIndexPath = [self findIndexPathAtDistance:distanceToTop fromIndexPath:self._visibleRange.start];
    VDIndexPath endIndexPath = [self findIndexPathAtDistance:distanceFromBottom fromIndexPath:self._visibleRange.end];
    
    VDIndexPath currentIndexPath = startIndexPath;
    NSMutableSet *mutableSet = [NSMutableSet set];
    
    while (!VDIndexPathEqualToIndexPath(currentIndexPath, endIndexPath))
    {
        [mutableSet addObject:[NSIndexPath indexPathWithVDIndexPath:currentIndexPath]];
        currentIndexPath.row++;
    }
    
    [mutableSet addObject:[NSIndexPath indexPathWithVDIndexPath:endIndexPath]];
    
    return [mutableSet copy];
}

- (void)updateVisibleRangeWithIndexPaths:(NSArray <NSIndexPath *> *)indexPaths
{
    __visibleRange = [self indexPathRangeForIndexPaths:indexPaths];
}

- (void)updateViewSize:(CGSize)viewSize factor:(CGFloat)factor
{
    self._viewSize = viewSize;
    self._factor = factor;
}

#pragma mark - Private

- (VDIndexPathRange)indexPathRangeForIndexPaths:(NSArray *)indexPaths
{
    
    __block VDIndexPathRange range = VDIndexPathRangeEmpty();
    
    if (indexPaths.count)
    {
        __block VDIndexPath currentIndexPath = [[indexPaths firstObject] VDIndexPathValue];
        range.start = currentIndexPath;
        range.end = currentIndexPath;
        
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            currentIndexPath = [indexPath VDIndexPathValue];
            range.start = VDIndexPathMinimum(range.start, currentIndexPath);
            range.end = VDIndexPathMaximum(range.end, currentIndexPath);
        }];
    }

    return range;
}

- (VDIndexPath)findIndexPathAtDistance:(CGFloat)distance fromIndexPath:(VDIndexPath)start
{
    VDIndexPath end = start;
    VDIndexPath previous = start;
    
    
    NSArray *completedSection = nil;
    VDAssert(_flags.didLoadItems,@"The delegate must support didLoadItems");
    if (_flags.didLoadItems)
    {
        completedSection = [self.delegate didLoadItems];
    }
    
    NSUInteger numberOfSections = completedSection.count;
    NSUInteger numberOfRowsInSection = [completedSection[end.section] count];
    
    VDAssert(_flags.itemAtIndexPath,@"The delegate must support itemAtIndexPath");
    if (distance < 0.0 && end.section >= 0 && end.section < numberOfSections && end.row >= 0 && end.row < numberOfRowsInSection) {
        
        while (distance < 0.0 && end.section >= 0 && end.row >= 0) {
            previous = end;
            VDDisplayItem *item = [self.delegate itemAtIndexPath:[NSIndexPath indexPathWithVDIndexPath:end]];
            
            CGFloat height = [item displayItemPlaceholderHeight];
            distance += height;
            end.row--;
            while (end.row < 0 && end.section > 0) {
                end.section--;
                numberOfRowsInSection = [(NSArray *)completedSection[end.section] count];
                end.row = numberOfRowsInSection - 1;
            }
        }
        
        if (end.row < 0) {
            end = previous;
        }
    } else {
        while (distance > 0.0 && end.section >= 0 && end.section < numberOfSections && end.row >= 0 && end.row < numberOfRowsInSection) {
            previous = end;
            VDDisplayItem *item = [self.delegate itemAtIndexPath:[NSIndexPath indexPathWithVDIndexPath:end]];
            CGFloat height = [item displayItemPlaceholderHeight];
            distance -= height;
            
            end.row++;
            while (end.row >= numberOfRowsInSection && end.section < numberOfSections - 1) {
                end.row = 0;
                end.section++;
                numberOfRowsInSection = [(NSArray *)completedSection[end.section] count];
            }
        }
        
        if (end.row >= numberOfRowsInSection) {
            end = previous;
        }
    }
    
    return end;
}

- (CGFloat)distanceWithViewSize:(CGFloat)viewSize forRangeType:(VDRangeType)rangeType
{
    CGFloat rangeFactor = 1.0;
    switch (rangeType) {
        case VDRangeType_Visible:
            rangeFactor = self._factor * 0.0;
            break;
        case VDRangeType_Display:
            rangeFactor = self._factor * 0.3;
            break;
        case VDRangeType_MesureLayout:
            rangeFactor = self._factor * 0.6;
            break;
        case VDRangeType_FetchData:
            rangeFactor = self._factor;
            break;
        case VDRangeType_OffScreen:
            rangeFactor = self._factor * 0.1;
            break;
        default:
            break;
    }
    
    return viewSize * rangeFactor;
}

#pragma mark - Getter & Setter

- (void)setDelegate:(id<VDLayoutControllerDelegate>)delegate
{
    _delegate = delegate;
    
    _flags.didLoadItems = [delegate respondsToSelector:@selector(didLoadItems)];
    _flags.itemAtIndexPath = [delegate respondsToSelector:@selector(itemAtIndexPath:)];
}

@end
