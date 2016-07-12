//
//  VDRangeController.h
//  VDRangeController
//
//  Created by vedon on 1/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "VDScrollDirection.h"
#import "VDDisplayItem.h"

@class VDRangeController;
@protocol VDRangeControllerDelegate <NSObject>

@required

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)displayItemsHasChanged:(NSArray <NSIndexPath *> *)indexPaths;

- (void)displayItemsWillChange:(NSArray <NSIndexPath *> *)indexPaths;

- (void)unvisibleItemsHasChange:(NSArray <NSIndexPath *> *)indexPaths;

- (void)didBeginUpdateInRangeController:(VDRangeController *)rangeController;

- (void)didEndUpdateInRangeController:(VDRangeController *)rangeController;

@end

@protocol VDRangeControllerDataSource <NSObject>

- (VDDisplayItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray <NSArray <VDDisplayItem *> *> *)didLoadItems;

- (NSArray <NSIndexPath *> *)visibleItemsIndexPaths;

@end

@interface VDRangeController : NSObject
@property (weak,nonatomic) id<VDRangeControllerDelegate> delegate;
@property (weak,nonatomic) id<VDRangeControllerDataSource> dataSource;

/**
 *  <#Description#>
 *
 *  @param factor          <#factor description#>
 *  @param view            <#view description#>
 *  @param delegate        <#delegate description#>
 *  @param dataSource      <#dataSource description#>
 *  @param layoutDirection <#layoutDirection description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithActiveAreaFactor:(CGFloat)factor
                         withContentView:(UIView *)view
                                delegate:(id<VDRangeControllerDelegate>) delegate
                              dataSource:(id<VDRangeControllerDataSource>) dataSource
                         layoutDirection:(VDScrollDirection)layoutDirection;


/**
 *  <#Description#>
 */
- (void)updateCurrentRange;

/**
 *  <#Description#>
 *
 *  @param scrollDirection <#scrollDirection description#>
 */
- (void)visibleItemsDidChangeWithScrollDirection:(VDScrollDirection)scrollDirection;

- (void)updateFactor:(CGFloat)factor;

@end
