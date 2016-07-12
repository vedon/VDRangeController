//
//  VDTableViewDataSourceProxy.m
//  VDRangeController
//
//  Created by vedon on 2/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDTableViewDataSourceProxy.h"
#import "VDTableView.h"

@implementation VDTableViewDataSourceProxy

- (instancetype)initWithTarget:(id)target interceptor:(id)interceptor
{
    self = [super initWithTarget:target interceptor:interceptor];
    if (self)
    {
        _proxyTarger.cellForRowAtIndexPath = [self.target respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)];
        _proxyTarger.numberOfRowsInSection = [self.target respondsToSelector:@selector(tableView:numberOfRowsInSection:)];
    }
    
    return self;
}


- (BOOL)intercepts:(SEL)selector
{
    return (
            
            selector == @selector(tableView:cellForRowAtIndexPath:)
            );
}
@end
