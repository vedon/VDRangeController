//
//  VDRangeController.m
//  VDRangeController
//
//  Created by vedon on 1/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//


#import "VDRangeController.h"
#import "VDAssert.h"
#import "VDLayoutController.h"
#import "VDInternalHelper.h"
#import "VDBaseDefine.h"


@interface VDRangeController ()<VDLayoutControllerDelegate>
{
@package
    struct VDRangeControllerDelegateFlags
    {
        unsigned heightForIndexPath:1;
        unsigned didBeginUpdate:1;
        unsigned didEndUpdate:1;
        unsigned displayItemsHasChanged:1;
        unsigned displayItemsWillChange:1;
        unsigned unvisibleItemsHasChange:1;
        
    }_delegateFlags;
    
    struct VDRangeControllerDataSourceFlags
    {
        unsigned itemAtIndexPath:1;
        unsigned didLoadItems:1;
        unsigned visibleItemsIndexPaths:1;
        
    }_dataSourceFlags;
}


@property (assign,nonatomic) VDScrollDirection _scrollDirection;
@property (assign,nonatomic) VDScrollDirection _layoutDirection;
@property (strong,nonatomic) VDLayoutController *_layoutController;

@property (assign,nonatomic) CGFloat _factor;
@property (weak,nonatomic) UIView *_contentView;
@property (assign,nonatomic) BOOL _rangeContrllerUpdate;
@property (assign,nonatomic) NSRange visibleRange;

@end

@implementation VDRangeController

- (instancetype)initWithActiveAreaFactor:(CGFloat)factor
                         withContentView:(UIView *)view
                                delegate:(id<VDRangeControllerDelegate>) delegate
                              dataSource:(id<VDRangeControllerDataSource>) dataSource
                         layoutDirection:(VDScrollDirection)layoutDirection
{
    self = [super init];
    if (self)
    {
        self._factor = factor;
        self._contentView = view;
        self.delegate = delegate;
        self.dataSource = dataSource;
        self._layoutDirection = layoutDirection;
        self._layoutController = [[VDLayoutController alloc] initWithLayoutDirection:layoutDirection viewSize:view.frame.size factor:factor delegate:self];
        
        
        _delegateFlags.heightForIndexPath     = [delegate respondsToSelector:@selector(heightForRowAtIndexPath:)];
        _delegateFlags.didBeginUpdate         = [delegate respondsToSelector:@selector(didBeginUpdateInRangeController:)];
        _delegateFlags.didEndUpdate           = [delegate respondsToSelector:@selector(didEndUpdateInRangeController:)];
        _delegateFlags.displayItemsHasChanged = [delegate respondsToSelector:@selector(displayItemsHasChanged:)];
        _delegateFlags.displayItemsWillChange = [delegate respondsToSelector:@selector(displayItemsWillChange:)];
        _delegateFlags.unvisibleItemsHasChange = [delegate respondsToSelector:@selector(unvisibleItemsHasChange:)];
    
        _dataSourceFlags.itemAtIndexPath        = [dataSource respondsToSelector:@selector(itemAtIndexPath:)];
        _dataSourceFlags.didLoadItems           = [dataSource respondsToSelector:@selector(didLoadItems)];
        _dataSourceFlags.visibleItemsIndexPaths = [dataSource respondsToSelector:@selector(visibleItemsIndexPaths)];
    }
    return self;
}

- (void)dealloc
{
    self._layoutController.delegate = nil;
}

#pragma mark - Public

- (void)visibleItemsDidChangeWithScrollDirection:(VDScrollDirection)direction
{
    if (__scrollDirection != direction)
    {
        __scrollDirection = direction;
    }
    [self scheduleRangeUpdate];
}

- (void)updateCurrentRange
{
    [self scheduleRangeUpdate];
}

- (void)updateFactor:(CGFloat)factor
{
    self._factor = factor;
    [self._layoutController updateViewSize:self._contentView.frame.size factor:factor];
}

#pragma mark - Private

- (void)scheduleRangeUpdate
{
    if (__rangeContrllerUpdate)
    {
        return;
    }
    __rangeContrllerUpdate = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performRangeUpdate];
    });
}

- (void)performRangeUpdate
{
    VDMainThreadGuard();
    [self updateDisplayItemsState];
}

- (void)updateDisplayItemsState
{
    NSArray <NSIndexPath *> *visibleItemsIndexPaths = nil;
    if (_dataSourceFlags.visibleItemsIndexPaths)
    {
        visibleItemsIndexPaths = [self.dataSource visibleItemsIndexPaths];
    }
    if (visibleItemsIndexPaths.count == 0)
    {
        __rangeContrllerUpdate = NO;
        return;
    }

    [self._layoutController updateVisibleRangeWithIndexPaths:visibleItemsIndexPaths];
    
    NSSet<NSIndexPath *> *visibleIndexPaths = [NSSet setWithArray:visibleItemsIndexPaths];

    NSSet<NSIndexPath *> *displayIndexPaths = nil;
    NSSet<NSIndexPath *> *mesureDataIndexPaths = nil;
    NSMutableSet<NSIndexPath *> *fetchDataIndexPaths = nil;
    NSMutableOrderedSet<NSIndexPath *> *allIndexPaths = [[NSMutableOrderedSet alloc] initWithSet:visibleIndexPaths];
    
    displayIndexPaths    = [self._layoutController indexPathsForScrollDirection:__scrollDirection rangeType:VDRangeType_Display];
    mesureDataIndexPaths = [self._layoutController indexPathsForScrollDirection:__scrollDirection rangeType:VDRangeType_MesureLayout];
    fetchDataIndexPaths  = [NSMutableSet setWithSet:[self._layoutController indexPathsForScrollDirection:__scrollDirection rangeType:VDRangeType_FetchData]];
    
    
    [allIndexPaths unionSet:displayIndexPaths];
    [allIndexPaths unionSet:mesureDataIndexPaths];
    [allIndexPaths unionSet:fetchDataIndexPaths];
    
    
    if (_delegateFlags.displayItemsWillChange)
    {
        [self.delegate displayItemsWillChange:displayIndexPaths.allObjects];
    }
    
    for (NSIndexPath *indexPath in allIndexPaths)
    {
        VDDisplayItem * displayItem = [self.dataSource itemAtIndexPath:indexPath];
        VDInterfaceState interfaceState = VDInterfaceState_Initialize;

        if ([visibleIndexPaths containsObject:indexPath])
        {
            interfaceState |= VDInterfaceState_Visible;
        }
        
        if ([displayIndexPaths containsObject:indexPath])
        {
            interfaceState |= VDInterfaceState_Display;
        }
        
        if ([mesureDataIndexPaths containsObject:indexPath])
        {
            interfaceState |= VDInterfaceState_MeasureLayout;
        }
        
        if ([fetchDataIndexPaths containsObject:indexPath])
        {
            interfaceState |= VDInterfaceState_FetchData;
        }
        
        displayItem.displayContentWidth = CGRectGetWidth(self._contentView.frame);
        [displayItem setInterfaceState:interfaceState];
        
    }
    
    if (_delegateFlags.displayItemsHasChanged)
    {
        [self.delegate displayItemsHasChanged:displayIndexPaths.allObjects];
    }
    
    if (_delegateFlags.unvisibleItemsHasChange)
    {
        [fetchDataIndexPaths minusSet:displayIndexPaths];
        NSSet <NSIndexPath *> *unvisibleIndexPaths= [NSSet setWithSet:fetchDataIndexPaths];
        
        [self.delegate unvisibleItemsHasChange:[unvisibleIndexPaths allObjects]];
    }

    __rangeContrllerUpdate = NO;

}

#pragma mark - VDLayoutControllerDelegate

- (NSArray <NSArray <VDDisplayItem *> *> *)didLoadItems
{
    VDAssert(_dataSourceFlags.didLoadItems,@"The RangeController must realize this");
    return [self.dataSource didLoadItems];
}

- (VDDisplayItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
     VDAssert(_dataSourceFlags.itemAtIndexPath,@"The RangeController must realize this");
    
    VDDisplayItem *displayItem = [self.dataSource itemAtIndexPath:indexPath];
    if (displayItem.displayContentWidth == 0)
    {
        displayItem.displayContentWidth = CGRectGetWidth(self._contentView.frame);
    }
    return displayItem;
}

@end
