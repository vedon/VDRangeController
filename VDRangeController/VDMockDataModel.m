//
//  VDMockData.m
//  VDRangeController
//
//  Created by vedon on 7/6/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDMockDataModel.h"
#import "VDData.h"
#import <UIKit/UIKit.h>

@interface VDMockDataModel ()

@end

@implementation VDMockDataModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.dataSource = [NSMutableArray array];
        for (int i = 0; i < 100; i++)
        {
            NSString *title = [[self randomString] stringByAppendingString:[NSString stringWithFormat:@"___%d",i]];
            VDData *item = [[VDData alloc] initWithTitle:title image:[UIImage imageNamed:@"Demo"] index:i];
            [self.dataSource addObject:item];
        }
    }
    return self;
}

#pragma mark - Util

- (NSString *)randomString
{
    NSString *randomString = @"";
    
    int randomNumber = arc4random() % 5;
    switch (randomNumber) {
        case 0:
            randomString  = @"Shu remarketed Shashibiya for a Chinese readership.";
            break;
        case 1:
            randomString  = @"Sha Weng, or Old Man Sha, became an icon of modernity amongst Chinese intellectuals.";
            break;
        case 2:
            randomString  = @"appreciation of Shakespeare. The playwright came with the personal endorsement of Karl Marx. He was also safely dead so unable to protest when his work was corralled into the service of socialist propagandaBut poor old Bill suffered a dramatic fall from grace during the Cultural Revolution. The new culture secretary, Jiang Qing (aka Madame Mao) had no time for Stratford’s ‘bourgeois counter-revolutionary’. She promptly banned the Bard, a prohibition that remained in force for ten years";
            break;
        case 3:
            randomString  = @"Interestingly, the removal of the Shakespeare ban in May 1977 was one of the signals that the Cultural Revolution was over";
            break;
        case 4:
            randomString  = @"Contemporary productions sometimes incorporate elements from traditional theatre, like music and dance. But they treat the original text with reverence – you’re unlikely to find a rapping Romeo on a Chinese stage.";
            break;
            
        default:
            break;
    }
    
    
    return randomString;
}
@end
