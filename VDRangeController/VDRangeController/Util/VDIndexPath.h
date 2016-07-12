//
//  VDIndexPath.h
//  VDRangeController
//
//  Created by vedon on 3/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDBaseDefine.h"

typedef struct {
    NSInteger section;
    NSInteger row;
} VDIndexPath;

typedef struct {
    VDIndexPath start;
    VDIndexPath end;
} VDIndexPathRange;

//Objective-C is slightly slower than straight C function calls because of the lookups involved in its dynamic nature. I'll edit this answer with more detail on how it works later if nobody else adds in the detail.
// The reason 👉 (http://www.xs-labs.com/en/blog/2012/01/16/mixing-cpp-objective-c/)
EXTERN_C_BEGIN

/**
 *  <#Description#>
 *
 *  @param section <#section description#>
 *  @param row     <#row description#>
 *
 *  @return <#return value description#>
 */
VDIndexPath VDIndexPathMake(NSInteger section, NSInteger row);


/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
VDIndexPath VDIndexPathEmpty();


/**
 *  <#Description#>
 *
 *  @param first  <#first description#>
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
VDIndexPath VDIndexPathMinimum(VDIndexPath first, VDIndexPath second);


/**
 *  <#Description#>
 *
 *  @param first  <#first description#>
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
VDIndexPath VDIndexPathMaximum(VDIndexPath first, VDIndexPath second);


/**
 *  <#Description#>
 *
 *  @param first  <#first description#>
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
VDIndexPathRange VDIndexPathRangeMake(VDIndexPath first, VDIndexPath second);


/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
VDIndexPathRange VDIndexPathRangeEmpty();

BOOL VDIndexPathEqualToIndexPath(VDIndexPath first, VDIndexPath second);

EXTERN_C_END

@interface NSIndexPath (VDIndexPathAdditions)

+ (NSIndexPath *)indexPathWithVDIndexPath:(VDIndexPath)indexPath;
- (VDIndexPath)VDIndexPathValue;

@end