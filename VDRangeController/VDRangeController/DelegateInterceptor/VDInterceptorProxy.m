//
//  VDInterceptorProxy.m
//  VDRangeController
//
//  Created by vedon on 2/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDInterceptorProxy.h"
#import "VDAssert.h"

@interface VDInterceptorProxy ()
@property (weak,nonatomic) id target;
@property (weak,nonatomic) id interceptor;
@end

@implementation VDInterceptorProxy

- (instancetype)initWithTarget:(id)target interceptor:(id)interceptor
{
    if (!self) {
        return nil;
    }
    
    _target = target?:[NSNull null];
    _interceptor = interceptor;

    return self;
}

- (BOOL)intercepts:(SEL)selector
{
    VDAssert(YES,@"Subclass must override it");
    return NO;
}


- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self intercepts:aSelector])
    {
        return [_interceptor respondsToSelector:aSelector];
    }
    else
    {
        return [_target respondsToSelector:aSelector];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self intercepts:aSelector]) {
        return _interceptor;
    } else {
        return [_target respondsToSelector:aSelector] ? _target : nil;
        
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    
    NSMethodSignature *methodSignature = nil;
    if ([self intercepts:aSelector]) {
        methodSignature = [[_interceptor class] instanceMethodSignatureForSelector:aSelector];
    } else {
        methodSignature = [[_target class] instanceMethodSignatureForSelector:aSelector];
    }
    
    return methodSignature ?: [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    //Do nothing
}

@end
