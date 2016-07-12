//
//  VDReusePool.h
//  VDRangeController
//
//  Created by vedon on 7/9/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDReusePool : NSObject

- (id)dequeueReuseObjectWithIdentifier:(NSString *)identifier;

- (void)enqueueReuseObject:(id)object identifier:(NSString *)identifier;

- (void)poolDrained;

@end
