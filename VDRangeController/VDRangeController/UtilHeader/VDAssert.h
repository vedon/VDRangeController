//
//  VDAssert.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#ifndef VDAssert_h
#define VDAssert_h

#define VDAssertWithSignal(condition, description, ...) NSAssert(condition, description, ##__VA_ARGS__)
#define VDAssert(...) NSAssert(__VA_ARGS__)

#define VDMainThreadGuard() VDAssertWithSignal([NSThread isMainThread], nil, @"This method must be called on the main thread")

#endif /* VDAssert_h */
