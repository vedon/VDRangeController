//
//  VDTableView.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDDataProtocol.h"

@class VDDisplayItem;
@protocol VDTableViewDisplayItemProtocol <NSObject>

/**
 *  Description
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (VDDisplayItem *)displayItemAtIndexPath:(NSIndexPath *)indexPath;

- (id)displayItemDataAtIndexPath:(NSIndexPath *)indexPath;


/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (NSArray <NSArray <id<VDDataProtocol>> *> *)didLoadsDisplayItems;


/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)estimateHeightForDisplayItem;

@end

@interface VDTableView : UITableView
@property (weak,nonatomic) id<VDTableViewDisplayItemProtocol> displayItemsDelegate;

/**
 *  <#Description#>
 *
 *  @param frame                <#frame description#>
 *  @param displayItemsDelegate <#displayItemsDelegate description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
         displayItemsDelegate:(id<VDTableViewDisplayItemProtocol>)displayItemsDelegate
       numberOfItemsToPreload:(NSUInteger)numberOfPreloadItems;

@end
