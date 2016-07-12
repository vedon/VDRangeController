//
//  MainThreadSentinel_Dispatcher.m
//  MainThreadSentinel
//
//  Created by vedon on 6/27/16.
//  Copyright © 2016 vedon. All rights reserved.
//

//#define kVDMainThreadDebugMode 1
#define kDefaultBatchSize 2

#import "VDMainThreadSentinel.h"
#import <deque>
#import <pthread.h>
#import "VDCallbackBlockWrapper.h"

typedef void (^AVMainThreadSentinelCallbackBlock) (id<VDMainThreadSentinelCallBackProtocol> callBackObject);

static void  runLoopSourcePerformAction(void *info)
{
#if kVDMainThreadDebugMode
    NSLog(@"Custome runloop wake up");
#endif
    //Do nothing ,just user for invoke the main thread
}

static void runLoopSourceScheduleRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode)
{
#if kVDMainThreadDebugMode
    NSLog(@"Observe the mode :%@",mode);
#endif
    
}


@interface VDMainThreadSentinel ()
{
    std::deque<id<VDMainThreadSentinelCallBackProtocol>> _internalQueue;
}

@property (nonatomic,assign) CFRunLoopRef _runLoop;
@property (nonatomic,assign) CFRunLoopObserverRef _runLoopObserver;
@property (nonatomic,assign) CFRunLoopSourceRef _runLoopSource;
@property (nonatomic,strong) NSRecursiveLock *_queueLock;
@property (nonatomic,assign) NSUInteger batchSize;
@property (nonatomic,copy) AVMainThreadSentinelCallbackBlock callbackBlock;
@end


@implementation VDMainThreadSentinel

+ (instancetype)shareDispatcher
{
    static VDMainThreadSentinel *_dispatcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dispatcher = [[VDMainThreadSentinel alloc] initWithCallbackBlock:^(id<VDMainThreadSentinelCallBackProtocol> callBackObject) {
            
            [callBackObject doSomethingToWakeUpMainRunLoop];
#if kVDMainThreadDebugMode
            NSLog(@"%@",[callBackObject description]);
#endif
        }];
    });
    
    return _dispatcher;
}

- (instancetype)initWithCallbackBlock:(AVMainThreadSentinelCallbackBlock)callbackBlock
{
    self = [super init];
    if (self)
    {
        self.callbackBlock = callbackBlock;
        [self configureSentinel];
    }
    return self;
}

- (void)configureSentinel
{
    
    /**
     *  The _internalQueue is base on the std::deque.Dude ,why don't you use NSMutableArray, because ,Base on the push and pop operation,I have test the 
     *  NSMutableArray and the std::dequeue ,the std::dequeue is better when deal with the push and pop operation.
     */
    _internalQueue = std::deque<id<VDMainThreadSentinelCallBackProtocol>>();
    __runLoop      = CFRunLoopGetMain();
    __queueLock    = [[NSRecursiveLock alloc] init];

    
    /**
     *  Add the runloop observer to the main runloop . The handlerBlock will be invoke when the main runloop want to sleep.
     *  The processActionWhenRunLoopWillSleep will signal the input source ,aka ,__runLoopSource and wake up the main run loop 
     *  to handle the input source event .After the input source is finish,it will sleep again.
     */
    void (^handlerBlock) (CFRunLoopObserverRef observer, CFRunLoopActivity activity) = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        [self processActionWhenRunLoopWillSleep];
    };
    __runLoopObserver = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, true, 0, handlerBlock);
    CFRunLoopAddObserver(__runLoop, __runLoopObserver,  kCFRunLoopDefaultMode);
    
    
    /**
     *  The input source for the main runloop which in order to wake up the main runloop to process the event.
     */
    CFRunLoopSourceContext *runLoopSourceContext = (CFRunLoopSourceContext *)calloc(1, sizeof(CFRunLoopSourceContext));
    runLoopSourceContext->perform = runLoopSourcePerformAction;
    runLoopSourceContext->schedule = runLoopSourceScheduleRoutine;
    __runLoopSource = CFRunLoopSourceCreate(NULL, 0, runLoopSourceContext);
    CFRunLoopAddSource(__runLoop, __runLoopSource, kCFRunLoopCommonModes);
    free(runLoopSourceContext);
    
    
    /**
     *  The batch size is use for the queue to decide the maximum event will be processed in per runloop cycle.
     */
    self.batchSize = kDefaultBatchSize;

}

- (void)dealloc
{
    if (CFRunLoopContainsSource(__runLoop, __runLoopSource, kCFRunLoopCommonModes))
    {
        CFRunLoopRemoveSource(__runLoop, __runLoopSource, kCFRunLoopCommonModes);
    }
    CFRelease(__runLoopSource);
    __runLoopSource = nil;
    
    if (CFRunLoopObserverIsValid(__runLoopObserver)) {
        CFRunLoopObserverInvalidate(__runLoopObserver);
    }
    CFRelease(__runLoopObserver);
    __runLoopObserver = nil;
}

#pragma mark - Private

- (void)processActionWhenRunLoopWillSleep
{
    BOOL isQueueDrained = NO;
    [__queueLock lock];
    if (!_internalQueue.empty())
    {
        std::deque<id<VDMainThreadSentinelCallBackProtocol>> itemsToProcess = std::deque<id<VDMainThreadSentinelCallBackProtocol>>();
        NSUInteger totalNodeCount = _internalQueue.size();

        for (int i = 0; i < MIN(self.batchSize, totalNodeCount); i++) {
            id node = _internalQueue[0];
            itemsToProcess.push_back(node);
            _internalQueue.pop_front();
        }
        
        if (_internalQueue.empty()) {
            isQueueDrained = YES;
        }
        
        unsigned long numberOfItems = itemsToProcess.size();
        for (int i = 0; i < numberOfItems; i++) {
            
            if (self.callbackBlock)
            {
                self.callbackBlock(itemsToProcess[i]);
            }
        }
        
        if (!isQueueDrained) {
            CFRunLoopSourceSignal(__runLoopSource);
            CFRunLoopWakeUp(__runLoop);
        }
    }
    [__queueLock unlock];
}

#pragma mark - Public

- (void)enqueue:(id<VDMainThreadSentinelCallBackProtocol>)object
{
    if (object)
    {
        [__queueLock lock];
        BOOL foundObject = NO;
        for (id currentObject : _internalQueue) {
            if (currentObject == object) {
                foundObject = YES;
                break;
            }
        }
        
        if (!foundObject) {
            _internalQueue.push_back(object);
            
            CFRunLoopSourceSignal(__runLoopSource);
            CFRunLoopWakeUp(__runLoop);
        }
        
        [__queueLock unlock];
    }
   
}

- (void)dequeue:(id<VDMainThreadSentinelCallBackProtocol>)object
{
    if (object)
    {
        [__queueLock lock];
        std::deque<id<VDMainThreadSentinelCallBackProtocol>>::iterator it = _internalQueue.begin();
        while (it != _internalQueue.end())
        {
            if ([object isEqual:*it])
            {
                _internalQueue.erase(it);
                break;
            }
            
            it++;
        }
        
        [__queueLock unlock];
    }
}

- (void)enqueueBlock:(VDCallbackWrapperBlock)callbackBlock
{
    if (callbackBlock)
    {
        VDCallbackBlockWrapper *wrapper = [[VDCallbackBlockWrapper alloc] initWithBlock:callbackBlock];
        [self enqueue:wrapper];
        wrapper = nil;
    }
}

@end
