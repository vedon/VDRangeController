//
//  VDTableViewDelegateProxy.m
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDTableViewDelegateProxy.h"
#import "VDTableView.h"


@implementation VDTableViewDelegateProxy

- (instancetype)initWithTarget:(id)target interceptor:(id)interceptor
{
    self = [super initWithTarget:target interceptor:interceptor];
    if (self)
    {
        _proxyTarger.scrollViewDidScroll = [self.target respondsToSelector:@selector(scrollViewDidScroll:)];
        
        _proxyTarger.willDisplayCell = [self.target respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)];
        _proxyTarger.didEndDisplayCell = [self.target respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)];
        
        _proxyTarger.scrollViewWillBeginDragging = [self.target respondsToSelector:@selector(scrollViewWillBeginDragging:)];
        _proxyTarger.scrollViewDidEndDragging = [self.target respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
        _proxyTarger.scrollViewWillEndDragging = [self.target respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
        _proxyTarger.heightForRowAtIndexPath = [self.target respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
    }
    
    
    return self;
}

- (BOOL)intercepts:(SEL)selector
{
    return (

            selector == @selector(scrollViewDidScroll:) ||
            
            selector == @selector(scrollViewDidEndDragging:willDecelerate:) ||
            selector == @selector(tableView:willDisplayCell:forRowAtIndexPath:) ||
            selector == @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:) ||
            
            selector == @selector(scrollViewWillBeginDragging:) ||
            selector == @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)
            );
}

@end
