//
//  VDInternalHelper.m
//  VDRangeController
//
//  Created by vedon on 7/4/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDInternalHelper.h"
#import <pthread.h>

static inline BOOL IsMain()
{
    return 0 != pthread_main_np();
}


void VDPerformBlockOnMainThread(void (^block)())
{
    if (IsMain()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}