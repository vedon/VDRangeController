//
//  MainThreadSentinel_Dispatcher.h
//  MainThreadSentinel
//
//  Created by vedon on 6/27/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDMainThreadSentinelCallBackProtocol.h"

@interface VDMainThreadSentinel : NSObject

/**
 *  The Sentinel
 *
 *  @return The share sentinel
 */
+ (instancetype)shareDispatcher;


/**
 *  Enqueue a object that conforms to the VDCallbackObjectProtocol protocol.If the object that already exist in the queue,it will be ignored.
 *
 *  @param object The Object conforms VDCallbackObjectProtocol and must implement the VDCallbackObjectProtocol require method
 */
- (void)enqueue:(id<VDMainThreadSentinelCallBackProtocol>)object;


/**
 *  Convenient method for the block base action,the block will invoke when the runloop is ready. The block will be wrapper by the VDCallbackBlockWrapper that conforms to the VDCallbackObjectProtocol.
 *
 *  @param callbackBlock The block you want to excute
 */
- (void)enqueueBlock:(VDCallbackWrapperBlock)callbackBlock;


- (void)dequeue:(id<VDMainThreadSentinelCallBackProtocol>)object;
@end
