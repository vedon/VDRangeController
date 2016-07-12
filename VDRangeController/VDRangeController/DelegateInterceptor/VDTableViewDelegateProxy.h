//
//  VDTableViewDelegateProxy.h
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDInterceptorProxy.h"

struct DelegateProxyTarget
{
    unsigned scrollViewDidScroll:1;
    
    unsigned willDisplayCell:1;
    unsigned didEndDisplayCell:1;
    
    unsigned scrollViewWillBeginDragging:1;
    unsigned scrollViewDidEndDragging:1;
    unsigned scrollViewWillEndDragging:1;
    
    unsigned heightForRowAtIndexPath:1;
};

@interface VDTableViewDelegateProxy : VDInterceptorProxy

/**
 *  <#Description#>
 */
@property (assign,nonatomic) struct DelegateProxyTarget proxyTarger;

@end
