//
//  VDDisplayItemProtocol.h
//  VDRangeController
//
//  Created by vedon on 2/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#ifndef VDDisplayItemProtocol_h
#define VDDisplayItemProtocol_h
#import <UIKit/UIKit.h>
#import "VDInterface.h"

@protocol VDDisplayItemProtocol;


typedef void (^VDVisibleBlock)(id<VDDisplayItemProtocol> displayItem);
typedef void (^VDDisplayBlock)(id<VDDisplayItemProtocol> displayItem);
typedef CGSize (^VDMeasureLayoutBlock)(id<VDDisplayItemProtocol> displayItem);
typedef void (^VDFetchDataBlock)(id<VDDisplayItemProtocol> displayItem);

@protocol VDDisplayItemProtocol <NSObject>

@required

- (VDInterfaceState)interfaceState;

- (void)setInterfaceState:(VDInterfaceState)interfaceState;

- (VDInterfaceState)getInterfaceState;

- (UIView *)displayView;

- (void)configureWithData:(id)displayItemData;

@end

#endif /* VDDisplayItemProtocol_h */
