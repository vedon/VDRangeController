//
//  DisplayItem.m
//  VDRangeController
//
//  Created by vedon on 3/7/2016.
//  Copyright © 2016 vedon. All rights reserved.
//




#import "VDDisplayItem.h"
#import <UIKit/UIKit.h>
#import <pthread.h>
#import "VDInternalHelper.h"
#import "VDBaseDefine.h"
#import "VDDisplayItemProcessQueue.h"
#import "VDOperation.h"
#import "VDMainThreadSentinel.h"
#import "VDMainThreadSentinelCallBackProtocol.h"
#import "VDAssert.h"
#import "VDLogControl.h"

static VDDisplayItemProcessQueue *processQueue;

@interface VDDisplayItem ()<VDMainThreadSentinelCallBackProtocol>
{
    NSRecursiveLock *_interfaceStateLock;
    pthread_mutex_t _measureBlockLock;
}

@property (copy,nonatomic) VDVisibleBlock visibleBlock;
@property (copy,nonatomic) VDDisplayBlock displayBlock;
@property (copy,nonatomic) VDMeasureLayoutBlock measureLayoutBlock;
@property (copy,nonatomic) VDFetchDataBlock fetchDataBlock;

@property (assign,nonatomic) CGSize measureLayoutSize;
@end


@implementation VDDisplayItem

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processQueue = [[VDDisplayItemProcessQueue alloc] init];
    });
    
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _interfaceState = VDInterfaceState_Initialize;
        _measureLayoutSize = CGSizeZero;
        _interfaceStateLock = [[NSRecursiveLock alloc] init];
        pthread_mutex_init(&_measureBlockLock, NULL);
    
        _measureLayoutSize = CGSizeZero;
        _displayItemBlockStatus.needDisplay = YES;
        _displayItemBlockStatus.needFetchData = YES;
        _displayItemBlockStatus.needMeasureLayout = YES;
    }
    return self;
}

- (void)configureWithVisible:(VDVisibleBlock)visibleBlock
                     display:(VDDisplayBlock)displayBlock
               measureLayout:(VDMeasureLayoutBlock)measureLayoutBlock
                   fetchData:(VDFetchDataBlock)fetchDataBlock
{
    // Future extensions
    self.visibleBlock = visibleBlock;
    
    /**
     *  The block will be called immediately when it appears on the screen. If not ,it will called if the main runloop will going to sleep.
     */
    self.displayBlock = displayBlock;
    
    /**
     *  Must return size(CGSize) for the item you want to display to the tableView. ps ,use for the tableView
     :cellForRowAtIndexPath:.
     */
    self.measureLayoutBlock = measureLayoutBlock;
    
    /**
     *  Fetch the data from local or the internet.The better experience is you can use some tech ,like data virtualization that cache the remote data to disk and fetch the data from local if need.
     */
    self.fetchDataBlock = fetchDataBlock;
}

- (void)configureWithDisplay:(VDDisplayBlock)displayBlock
               measureLayout:(VDMeasureLayoutBlock)measureLayoutBlock
                   fetchData:(VDFetchDataBlock)fetchDataBlock
{

    [self configureWithVisible:^(id<VDDisplayItemProtocol> displayItem) {
    
        //Do nothing;
        
    } display:displayBlock measureLayout:measureLayoutBlock fetchData:fetchDataBlock];
}


#pragma mark - Private

- (void)invokeCallbackBlockFromInterfaceState:(VDInterfaceState)oldInterfaceState
                             toInterfaceState:(VDInterfaceState)newInterfaceState
                                  displayItem:(VDDisplayItem *)displayItem
{

    BOOL shouldInvokeCallback = oldInterfaceState != newInterfaceState;
#ifdef kVDDisplayItemDetailLog
    shouldInvokeCallback = YES;
#endif
    if (shouldInvokeCallback)
    {
        if(VDInterfaceStateIncludesDisplay(newInterfaceState))
        {
            _displayItemBlockStatus.needDisplay = YES;
            [self displayWithDisplayItem:displayItem oldInterfaceState:oldInterfaceState];
        }
        
        if (VDInterfaceStateIncludesVisible(newInterfaceState))
        {
            [self visibleWithDisplayItem:displayItem];
        }
        
        if (VDInterfaceStateIncludesMeasureLayout(newInterfaceState))
        {
            _displayItemBlockStatus.needMeasureLayout = YES;
            [self measureLayoutWithDisplayItem:displayItem async:YES];
            
        }
        if (VDInterfaceStateIncludesFetchData(newInterfaceState))
        {
            _displayItemBlockStatus.needFetchData = YES;
            [self fetchDataWithDisplayItem:displayItem];
        }
    }
}

- (void)visibleWithDisplayItem:(VDDisplayItem *)displayItem
{
    if ([displayItem visibleBlock])
    {
        /**
         *  When the interface turn to display ,it guarantee to be excute on main thread!
         */
        VDPerformBlockOnMainThread(^{
            
            [self performDisplayBlock:displayItem];
            [self visibleBlock](displayItem);
        });
        VDDisplayItemLog(@"\t%@\t\t**Visible**",[displayItem description]);
    }
    
}

- (void)displayWithDisplayItem:(VDDisplayItem *)displayItem oldInterfaceState:(VDInterfaceState)oldInterfaceState
{
    [[VDMainThreadSentinel shareDispatcher] enqueue:self];
}

- (void)measureLayoutWithDisplayItem:(VDDisplayItem *)displayItem async:(BOOL)async
{
    if ([displayItem measureLayoutBlock])
    {
        if (async)
        {
            __weak __typeof(displayItem) weakDisplayItem = displayItem;
            [processQueue addOperation:[VDOperation blockOperationWithBlock:^{
                
                __strong __typeof(weakDisplayItem)strongDisplayItem = weakDisplayItem;
                [self perfromMeasureBlock:strongDisplayItem];
                
            }]];
        }
        else
        {
            [self perfromMeasureBlock:displayItem];
        }
    }
}


- (void)performDisplayBlock:(VDDisplayItem *)displayItem
{
    VDMainThreadGuard();
    if (displayItem.displayBlock &&
        VDInterfaceStateIncludesDisplay(displayItem.interfaceState))
    {
        if (!CGSizeEqualToSize(self.displayContentView.frame.size, CGSizeMake(self.displayContentWidth, self.displayContentHeight)))
        {
            self.displayContentView.frame = CGRectMake(0, 0, self.displayContentWidth, self.displayContentHeight);
            [self.displayContentView setNeedsLayout];
            [self.displayContentView layoutIfNeeded];
        }
        
        displayItem.displayBlock(displayItem);
        _displayItemBlockStatus.needDisplay = NO;
        
        VDDisplayItemLog(@"\t%@\t\t**display**",[displayItem description]);
    }
}

- (void)perfromMeasureBlock:(VDDisplayItem *)displayItem
{
    pthread_mutex_lock(&_measureBlockLock);
    
    if (displayItem.measureLayoutBlock)
    {
        CGSize measureLayoutSize = [displayItem measureLayoutBlock](displayItem);
        displayItem.measureLayoutSize = measureLayoutSize;
    
        if (measureLayoutSize.width > 0 && measureLayoutSize.height > 0)
        {
            displayItem.measureLayoutBlock = nil;
            _displayItemBlockStatus.needMeasureLayout = NO;
        }
        VDDisplayItemLog(@"\t%@\t\t**MeasureLayout**",[displayItem description]);
    }
    
    pthread_mutex_unlock(&_measureBlockLock);
}

- (void)fetchDataWithDisplayItem:(VDDisplayItem *)displayItem
{
    if ([displayItem fetchDataBlock])
    {
        [displayItem fetchDataBlock](displayItem);
        displayItem.fetchDataBlock = nil;
        
        _displayItemBlockStatus.needFetchData = NO;
        VDDisplayItemLog(@"\t%@\t\t**FetchData**",[displayItem description]);
    }
}


#pragma mark - VDDisplayItemProtocol

- (UIView *)displayView
{
    VDAssert(NO,@"Subclass must override this function");
    return nil;
}

- (void)configureWithData:(id)displayItemData
{
    VDAssert(NO,@"Subclass must override this function");
}

#pragma mark - VDDisplayItemLayoutProtocol

- (CGFloat)displayContentHeight
{
    CGFloat height = 0;
    if (CGSizeEqualToSize(CGSizeZero, self.measureLayoutSize))
    {
        [self measureLayoutWithDisplayItem:self async:NO];
    }
    height = self.measureLayoutSize.height;

    return height;
}

#pragma mark - VDReusePoolProtocol

- (NSString *)resueDisplayViewIdentifier
{
    VDAssert(NO,@"Subclass must override this function");
    return nil;
}

#pragma mark - VDMainThreadSentinelCallBackProtocol

- (void)doSomethingToWakeUpMainRunLoop
{
    if (_displayItemBlockStatus.needDisplay)
    {
        [self performDisplayBlock:self];
    }
    
}

#pragma mark - Getter & Setter

- (VDInterfaceState)getInterfaceState
{
    VDInterfaceState interfaceState = VDInterfaceState_Initialize;
    [_interfaceStateLock lock];
    interfaceState = _interfaceState;
    [_interfaceStateLock unlock];
    
    return interfaceState;
}

- (void)setInterfaceState:(VDInterfaceState)interfaceState
{

    [_interfaceStateLock lock];
    
    VDInterfaceState oldInterfaceState = _interfaceState;
    if (_interfaceState != interfaceState)
    {
        _interfaceState = interfaceState;
    }
    
    [self invokeCallbackBlockFromInterfaceState:oldInterfaceState toInterfaceState:interfaceState displayItem:self];
    
    [_interfaceStateLock unlock];
}

- (CGFloat)displayItemPlaceholderHeight
{
    VDAssert(_displayItemPlaceholderHeight != 0,@"Hey dude ,you must set a placeholder height for the table to estimate the height of the item");
    return _displayItemPlaceholderHeight;
}


@end
