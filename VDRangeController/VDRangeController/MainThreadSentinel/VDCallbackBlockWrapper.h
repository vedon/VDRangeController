//
//  VDCallbackBlockWrapper.h
//  MainThreadSentinel
//
//  Created by vedon on 6/27/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDMainThreadSentinelCallBackProtocol.h"

@interface VDCallbackBlockWrapper : NSObject<VDMainThreadSentinelCallBackProtocol>

/**
 *  Wrapper for the block base action
 *
 *  @param callbackBlock The block will excute when the runloop is ready.
 *
 *  @return Wrapper The Wrapper will excute the callbackBlock when the runloop invoke
 */

- (instancetype)initWithBlock:(VDCallbackWrapperBlock)callbackBlock;

@end
