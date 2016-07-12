//
//  ViewController.m
//  VDRangeController
//
//  Created by vedon on 1/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "ViewController.h"
#import "VDTableView.h"
#import "LeftTextRightImageDisplayItem.h"
#import "VDMockDataModel.h"

static NSString *cellIdentifier = @"Cell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,VDTableViewDisplayItemProtocol>
@property (strong,nonatomic) VDTableView *contentTable;
@property (strong,nonatomic) VDMockDataModel *dataModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = [[VDMockDataModel alloc] init];
    self.contentTable = [[VDTableView alloc] initWithFrame:self.view.bounds displayItemsDelegate:self numberOfItemsToPreload:10];
    self.contentTable.delegate = self;
    self.contentTable.dataSource = self;
    
    [self.view addSubview:self.contentTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentTable.frame  = self.view.bounds;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VDDisplayItem *displayItem = [self displayItemAtIndexPath:indexPath];
    CGFloat height = [displayItem displayContentHeight];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VDDisplayItem *displayItem = [self displayItemAtIndexPath:indexPath];
    return [displayItem displayItemPlaceholderHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    VDDisplayItem *displayItem = [self displayItemAtIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:[displayItem displayContentView]];

    return cell;
}

#pragma mark - VDTableViewDisplayItemProtocol

- (VDDisplayItem *)displayItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<VDDataProtocol> data = [[self didLoadsDisplayItems][indexPath.section] objectAtIndex:indexPath.row];
    return [data displayItem];
}

- (id)displayItemDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self didLoadsDisplayItems][indexPath.section] objectAtIndex:indexPath.row];
}

- (NSArray <NSArray <id<VDDataProtocol>> *> *)didLoadsDisplayItems
{
    return @[self.self.dataModel.dataSource];
}

- (CGFloat)estimateHeightForDisplayItem
{
    return 60;
}


@end
