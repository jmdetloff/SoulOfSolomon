//
//  BellView.m
//  LudumDare27
//
//  Created by John Detloff on 8/25/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "BellView.h"

@implementation BellView

static NSString * const kRingAnimationKey = @"kRingAnimationKey";
static NSString * const kBellAnimationKey = @"kBellAnimationKey";


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *ring = @[[UIImage imageNamed:@"object_bell0000.png"],
                        [UIImage imageNamed:@"object_bell0001.png"],
                        [UIImage imageNamed:@"object_bell0002.png"],
                        [UIImage imageNamed:@"object_bell0003.png"],
                          [UIImage imageNamed:@"object_bell0004.png"],
                          [UIImage imageNamed:@"object_bell0005.png"],
                          [UIImage imageNamed:@"object_bell0006.png"],
                          [UIImage imageNamed:@"object_bell0007.png"],
                          [UIImage imageNamed:@"object_bell0008.png"],
                          [UIImage imageNamed:@"object_bell0009.png"]];
        
        NSArray *bell = @[[UIImage imageNamed:@"object_bell0000"]];
        
        [self setAnimation:ring duration:1 forKey:kRingAnimationKey];
        [self setAnimation:bell duration:1.2 forKey:kBellAnimationKey];
        
        [self setAnimationToAnimationWithKey:kBellAnimationKey];
        
    }
    return self;
}


- (void)ring {
    [self setAnimationToAnimationWithKey:kRingAnimationKey];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setAnimationToAnimationWithKey:kBellAnimationKey];
    });
}


@end
