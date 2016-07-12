//
//  DisplayItem.h
//  VDRangeController
//
//  Created by vedon on 3/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDDisplayItemProtocol.h"
#import "VDReusePoolProtocol.h"
#import "VDDisplayItemLayoutProtocol.h"

@interface VDDisplayItem : NSObject<VDDisplayItemProtocol,VDReusePoolProtocol,VDDisplayItemLayoutProtocol>
{
    struct  VDDisplayItemBlockStatus
    {
        unsigned needDisplay:1;
        unsigned needMeasureLayout:1;
        unsigned needFetchData:1;
        
    }_displayItemBlockStatus;
}
/**
 *  <#Description#>
 */
@property (assign,nonatomic) VDInterfaceState interfaceState;

/**
 *  <#Description#>
 */
@property (assign,nonatomic) CGFloat displayItemPlaceholderHeight;

/**
 *  <#Description#>
 */
@property (assign,nonatomic) CGFloat displayContentWidth;

/**
 *  <#Description#>
 */
@property (strong,nonatomic) UIView *displayContentView;

/**
 *  Convenient method for configuring the blocks
 *
 *  @param displayBlock       The block will be called when the item enter the display area. The area defined in VDLayoutController
 *  @param measureLayoutBlock The block will be called when the item enter the measure area. The area defined in VDLayoutController
 *  @param fetchDataBlock     The block will be called when the item enter the fetchData area. The area defined in VDLayoutController
 */

- (void)configureWithDisplay:(VDDisplayBlock)displayBlock
               measureLayout:(VDMeasureLayoutBlock)measureLayoutBlock
                   fetchData:(VDFetchDataBlock)fetchDataBlock;

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (VDVisibleBlock)visibleBlock;

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (VDDisplayBlock)displayBlock;

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (VDMeasureLayoutBlock)measureLayoutBlock;

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (VDFetchDataBlock)fetchDataBlock;

@end
