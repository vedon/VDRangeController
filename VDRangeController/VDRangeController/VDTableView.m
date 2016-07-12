//
//  VDTableView.m
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDTableView.h"
#import "VDTableViewDelegateProxy.h"
#import "VDTableViewDataSourceProxy.h"
#import "VDScrollDirection.h"
#import "VDRangeController.h"
#import "VDAssert.h"
#import "VDReusePool.h"
#import "VDDataProtocol.h"

@interface VDTableView()<VDRangeControllerDelegate,VDRangeControllerDataSource>
@property (strong,nonatomic) VDTableViewDelegateProxy *_tableViewDelegateProxy;
@property (strong,nonatomic) VDTableViewDataSourceProxy *_tableViewDataSourceProxy;
@property (strong,nonatomic) VDRangeController *_rangeController;
@property (assign,nonatomic) CGPoint _deceleratingVelocity;
@property (strong,nonatomic) NSIndexPath *catlikeIndexPath;
@property (strong,nonatomic) VDReusePool *_reusePool;
@property (assign,nonatomic) NSUInteger numberOfPreloadItems;
@end

@implementation VDTableView

- (instancetype)initWithFrame:(CGRect)frame
         displayItemsDelegate:(id<VDTableViewDisplayItemProtocol>)displayItemsDelegate
       numberOfItemsToPreload:(NSUInteger)numberOfPreloadItems
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.numberOfPreloadItems = numberOfPreloadItems;
        self.displayItemsDelegate = displayItemsDelegate;
        self._rangeController = [[VDRangeController alloc]
                                 initWithActiveAreaFactor:[self calculateFactorWithNumberOfItemsToPreload:numberOfPreloadItems]
                                 withContentView:self
                                 delegate:self
                                 dataSource:self
                                 layoutDirection:VDScrollDirectionVer];
    }
    return self;
}

- (void)dealloc
{
    self._tableViewDelegateProxy = nil;
    self._tableViewDataSourceProxy = nil;
    self._rangeController.delegate = nil;
    self._rangeController.dataSource = nil;
    [self._reusePool poolDrained];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self._rangeController updateFactor:[self calculateFactorWithNumberOfItemsToPreload:self.numberOfPreloadItems]];

}

#pragma mark - ScrollView Event

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self._tableViewDelegateProxy.proxyTarger.scrollViewDidScroll)
    {
        [self._tableViewDelegateProxy.target scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    __deceleratingVelocity = CGPointMake(scrollView.contentOffset.x - ((targetContentOffset != NULL) ? targetContentOffset->x : 0),
                                        scrollView.contentOffset.y - ((targetContentOffset != NULL) ? targetContentOffset->y : 0)
                                        );
    if (self._tableViewDelegateProxy.proxyTarger.scrollViewWillEndDragging)
    {
        [self._tableViewDelegateProxy.target scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.catlikeIndexPath = indexPath;
    [self._rangeController visibleItemsDidChangeWithScrollDirection:[self scrollDirection]];
    if (self._tableViewDelegateProxy.proxyTarger.willDisplayCell)
    {
        [self._tableViewDelegateProxy.target tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self._tableViewDelegateProxy.proxyTarger.didEndDisplayCell)
    {
        [self._tableViewDelegateProxy.target tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
    
    self.catlikeIndexPath = nil;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  Dequeue the reuse view for the display item ,if the reusePool return nil with the reuseDisplayViewIdentifier
     *  it will ask the displayItem to create one.
     */
    VDDisplayItem *displayItem = [self.displayItemsDelegate displayItemAtIndexPath:indexPath];
    displayItem.displayContentWidth = CGRectGetWidth(tableView.frame);
    if (displayItem)
    {
        if (!displayItem.displayContentView)
        {
            UIView *displayView = (UIView *)[self._reusePool dequeueReuseObjectWithIdentifier:[displayItem resueDisplayViewIdentifier]];
            if (!displayView)
            {
                displayView = [displayItem displayView];
            }
            displayItem.displayContentView = displayView;
        }
    }
    
    if (self._tableViewDataSourceProxy.proxyTarger.cellForRowAtIndexPath)
    {
        return [self._tableViewDelegateProxy.target tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self._tableViewDataSourceProxy.proxyTarger.numberOfRowsInSection)
    {
        return [self._tableViewDelegateProxy.target tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

#pragma mark - Override

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    self._tableViewDataSourceProxy = [[VDTableViewDataSourceProxy alloc] initWithTarget:dataSource interceptor:self];
    super.dataSource = (id<UITableViewDataSource>)self._tableViewDataSourceProxy;;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self._tableViewDelegateProxy = [[VDTableViewDelegateProxy alloc] initWithTarget:delegate interceptor:self];
    super.delegate = (id<UITableViewDelegate>)self._tableViewDelegateProxy;
}

#pragma mark - Private

- (VDScrollDirection)scrollDirection
{
    CGPoint scrollVelocity;
    if (self.isTracking) {
        scrollVelocity = [self.panGestureRecognizer velocityInView:self.superview];
    } else {
        scrollVelocity = __deceleratingVelocity;
    }
    
    VDScrollDirection scrollDirection = [self _scrollDirectionForVelocity:scrollVelocity];
    return scrollDirection;
}

- (VDScrollDirection)_scrollDirectionForVelocity:(CGPoint)scrollVelocity
{
    VDScrollDirection direction = VDScrollDirectionNone;
    VDScrollDirection scrollableDirections = [self scrollableDirections];
    
    if (VDScrollDirectionContainersVer(scrollableDirections)) { // Can scroll vertically.
        if (scrollVelocity.y < 0.0) {
            direction |= VDScrollDirectionDown;
        } else if (scrollVelocity.y > 0.0) {
            direction |= VDScrollDirectionUp;
        }
    }
    
    return direction;
}

- (VDScrollDirection)scrollableDirections
{
    VDScrollDirection scrollableDirection = VDScrollDirectionNone;
    CGFloat totalContentWidth  = self.contentSize.width + self.contentInset.left + self.contentInset.right;
    CGFloat totalContentHeight = self.contentSize.height + self.contentInset.top + self.contentInset.bottom;
    
    if (self.alwaysBounceHorizontal || totalContentWidth > self.bounds.size.width) {
        scrollableDirection |= VDScrollDirectionHor;
    }
    if (self.alwaysBounceVertical || totalContentHeight > self.bounds.size.height) {
        scrollableDirection |= VDScrollDirectionVer;
    }
    return scrollableDirection;
}

- (CGFloat)calculateFactorWithNumberOfItemsToPreload:(NSUInteger)numberOfPreloadItems
{
    CGFloat factor = 1.0;
    
    VDAssert([self.displayItemsDelegate respondsToSelector:@selector(estimateHeightForDisplayItem)],@"The delegate must realize the estimateHeightForDisplayItem method");
    
    if ([self.displayItemsDelegate respondsToSelector:@selector(estimateHeightForDisplayItem)])
    {
        CGFloat estimateHeight = [self.displayItemsDelegate estimateHeightForDisplayItem];
        CGFloat contentHeightForCalculatedItems = numberOfPreloadItems * estimateHeight / 2;
        
        factor = contentHeightForCalculatedItems / ceil(CGRectGetHeight(self.frame));
    }
   
    return factor;
}

#pragma mark - VDRangeControllerDelegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
}

//- (void)displayItemsWillChange:(NSArray<NSIndexPath *> *)indexPaths
//{
//    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        VDDisplayItem *displayItem = [self.displayItemsDelegate displayItemAtIndexPath:obj];
//        if (displayItem)
//        {
//            id displayItemData = [self.displayItemsDelegate displayItemDataAtIndexPath:obj];
//            [displayItem configureWithData:displayItemData];
//        }
//    }];
//}

- (void)displayItemsHasChanged:(NSArray <NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VDDisplayItem * displayItem = [self.displayItemsDelegate displayItemAtIndexPath:obj];
        UIView *displayContentView = displayItem.displayContentView;
        if (displayContentView == nil)
        {
            displayItem.displayContentView = [self._reusePool dequeueReuseObjectWithIdentifier:displayItem.resueDisplayViewIdentifier];
        }
    }];
}

- (void)unvisibleItemsHasChange:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        VDDisplayItem * displayItem = [self.displayItemsDelegate displayItemAtIndexPath:obj];
        UIView *displayContentView = displayItem.displayContentView;
        if (displayContentView)
        {
            [self._reusePool enqueueReuseObject:displayContentView identifier:displayItem.resueDisplayViewIdentifier];
        }
        displayItem.displayContentView = nil;
    }];
}

#pragma mark - VDRangeControllerDataSource

- (VDDisplayItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.displayItemsDelegate displayItemAtIndexPath:indexPath];
}

- (NSArray <NSArray <VDDisplayItem *> *> *)didLoadItems
{
    return (NSArray <NSArray <VDDisplayItem *> *> *)[self.displayItemsDelegate didLoadsDisplayItems];
}


- (NSArray <NSIndexPath *> *)visibleItemsIndexPaths
{
    NSArray <UITableViewCell *> *cells = [self visibleCells];
    NSMutableArray *visibleIndexPaths = [NSMutableArray array];
    [cells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [visibleIndexPaths addObject:[self indexPathForCell:obj]];
        
    }];
    
    if (self.catlikeIndexPath)
    {
        if (![visibleIndexPaths containsObject:self.catlikeIndexPath])
        {
            [visibleIndexPaths addObject:self.catlikeIndexPath];
    
        }
    }
    
    return [visibleIndexPaths copy];
}

#pragma mark - Getter & Setter

- (VDReusePool *)_reusePool
{
    if (!__reusePool)
    {
        __reusePool = [[VDReusePool alloc] init];
    }
    return __reusePool;
}

@end
