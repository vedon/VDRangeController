//
//  VDLayoutController.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDScrollDirection.h"

typedef NS_ENUM(NSUInteger,VDRangeType)
{
    VDRangeType_Visible,
    VDRangeType_Display,
    VDRangeType_MesureLayout,
    VDRangeType_FetchData,
    VDRangeType_OffScreen,
};

@class VDDisplayItem;
@protocol VDLayoutControllerDelegate <NSObject>

- (NSArray <NSArray <VDDisplayItem *> *> *)didLoadItems;

- (VDDisplayItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface VDLayoutController : NSObject
@property (weak,nonatomic) id<VDLayoutControllerDelegate> delegate;


/**
 *  <#Description#>
 *
 *  @param layoutDirection <#layoutDirection description#>
 *  @param viewSize        <#viewSize description#>
 *  @param factor          <#factor description#>
 *  @param delegate        <#delegate description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithLayoutDirection:(VDScrollDirection)layoutDirection
                               viewSize:(CGSize)viewSize
                                 factor:(CGFloat)factor
                               delegate:(id<VDLayoutControllerDelegate>)delegate;


/**
 *  <#Description#>
 *
 *  @param scrollDirection <#scrollDirection description#>
 *  @param rangeType       <#rangeType description#>
 *
 *  @return <#return value description#>
 */
- (NSSet <NSIndexPath *> *)indexPathsForScrollDirection:(VDScrollDirection)scrollDirection rangeType:(VDRangeType)rangeType;


/**
 *  <#Description#>
 *
 *  @param indexPaths <#indexPaths description#>
 */
- (void)updateVisibleRangeWithIndexPaths:(NSArray <NSIndexPath *> *)indexPaths;

- (void)updateViewSize:(CGSize)viewSize factor:(CGFloat)factor;

@end
