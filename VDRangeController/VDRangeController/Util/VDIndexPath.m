//
//  VDIndexPath.m
//  VDRangeController
//
//  Created by vedon on 3/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDIndexPath.h"
#import <UIKit/UIKit.h>


VDIndexPath VDIndexPathMake(NSInteger section, NSInteger row)
{
    VDIndexPath indexPath;
    indexPath.section = section;
    indexPath.row = row;
    return indexPath;
}

VDIndexPath VDIndexPathEmpty()
{
    return VDIndexPathMake(0, 0);
}


VDIndexPath VDIndexPathMinimum(VDIndexPath first, VDIndexPath second)
{
    if (first.section < second.section) {
        return first;
    } else if (first.section > second.section) {
        return second;
    } else {
        return (first.row < second.row ? first : second);
    }
}

VDIndexPath VDIndexPathMaximum(VDIndexPath first, VDIndexPath second)
{
    if (first.section > second.section) {
        return first;
    } else if (first.section < second.section) {
        return second;
    } else {
        return (first.row > second.row ? first : second);
    }
}

VDIndexPathRange VDIndexPathRangeMake(VDIndexPath first, VDIndexPath second)
{
    VDIndexPathRange range;
    range.start = VDIndexPathMinimum(first, second);
    range.end = VDIndexPathMaximum(first, second);
    return range;
}

VDIndexPathRange VDIndexPathRangeEmpty()
{
    return VDIndexPathRangeMake(VDIndexPathEmpty(), VDIndexPathEmpty());
}

BOOL VDIndexPathEqualToIndexPath(VDIndexPath first, VDIndexPath second)
{
    return (first.section == second.section && first.row == second.row);
}


@implementation NSIndexPath (VDIndexPathAdditions)

+ (NSIndexPath *)indexPathWithVDIndexPath:(VDIndexPath)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];;
}

- (VDIndexPath)VDIndexPathValue
{
    return VDIndexPathMake(self.section, self.row);
}

@end