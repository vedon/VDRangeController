//
//  VDFetchContext.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDFetchContext : NSObject

- (BOOL)isFetching;

- (BOOL)didCancelFetching;

- (void)beginFetching;

- (void)completeFetching;

- (void)cancelFetching;

@end
