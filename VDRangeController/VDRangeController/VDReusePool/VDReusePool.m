//
//  VDReusePool.m
//  VDRangeController
//
//  Created by vedon on 7/9/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDReusePool.h"
#import "VDAssert.h"
#import <UIKit/UIApplication.h>
#import "VDReuseObject.h"
#import "VDBaseDefine.h"
#import "VDLogControl.h"


@interface VDReusePool ()
@property (strong,nonatomic) NSMutableSet *_pool;

@end

@implementation VDReusePool

- (id)dequeueReuseObjectWithIdentifier:(NSString *)identifier
{
    VDMainThreadGuard();
    
    VDReuseObject *reuseObject = nil;
    if (identifier.length)
    {
        for (VDReuseObject *enumerateObject in self._pool)
        {
            if ([enumerateObject.resueDisplayViewIdentifier isEqualToString:identifier])
            {
                reuseObject = enumerateObject;
                VDReusePoolLog(@"Dequeue:%@",reuseObject.object);
                break;
            }
        }
    }
    if (reuseObject)
    {
        [self._pool removeObject:reuseObject];
    }
    
    VDReusePoolLog(@"%@",[self description]);
    
    return reuseObject.object;
}

- (void)enqueueReuseObject:(id)object identifier:(NSString *)identifier
{
    VDMainThreadGuard();
    if (object)
    {
        VDReuseObject *reuseObject = [[VDReuseObject alloc] init];
        reuseObject.object = object;
        reuseObject.resueDisplayViewIdentifier = identifier;
        
        VDReusePoolLog(@"Enqueue:%@",reuseObject.object);
        [self._pool addObject:reuseObject];
    }
    
    VDReusePoolLog(@"%@",[self description]);
}

- (void)poolDrained
{
    VDMainThreadGuard();
    [self._pool removeAllObjects];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Pool: %lu objects",(unsigned long)self._pool.allObjects.count];
}

#pragma mark - Getter & Setter

- (NSMutableSet *)_pool
{
    if (!__pool)
    {
        __pool = [[NSMutableSet alloc] init];
    }
    
    return __pool;
}
@end
