//
//  VDTableViewDataSourceProxy.h
//  VDRangeController
//
//  Created by vedon on 2/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDInterceptorProxy.h"

struct DataSourceProxyTarget
{
    unsigned cellForRowAtIndexPath:1;
    unsigned numberOfRowsInSection:1;
};

@interface VDTableViewDataSourceProxy : VDInterceptorProxy
@property (assign,nonatomic) struct DataSourceProxyTarget proxyTarger;
@end
