//
//  VDInterceptorProxy.h
//  VDRangeController
//
//  Created by vedon on 2/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDInterceptorProxy : NSProxy
@property (weak,nonatomic,readonly) id target;

- (instancetype)initWithTarget:(id)target interceptor:(id)interceptor;

@end
