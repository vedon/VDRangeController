//
//  VDMainThreadSentinelCallBackProtocol.h
//  VDRangeController
//
//  Created by vedon on 6/27/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#ifndef VDMainThreadSentinelCallBackProtocol_h
#define VDMainThreadSentinelCallBackProtocol_h

typedef void (^VDCallbackWrapperBlock)();

@protocol VDMainThreadSentinelCallBackProtocol <NSObject>

@required

/**
 *  The action will be invoke when the runloop is go to sleep.
 */

- (void)doSomethingToWakeUpMainRunLoop;

@end


#endif /* VDMainThreadSentinelCallBackProtocol_h */