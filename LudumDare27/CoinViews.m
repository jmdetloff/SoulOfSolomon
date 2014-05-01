//
//  CoinViews.m
//  LudumDare27
//
//  Created by John Detloff on 8/25/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "CoinViews.h"

@implementation CoinViews

static NSString * const kCoinAnimationKey = @"kCoinAnimationKey";

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *coin = @[[UIImage imageNamed:@"coin_shimmer0000.png"],
                          [UIImage imageNamed:@"coin_shimmer0001.png"],
                          [UIImage imageNamed:@"coin_shimmer0002.png"],
                          [UIImage imageNamed:@"coin_shimmer0003.png"],
                          [UIImage imageNamed:@"coin_shimmer0004.png"],
                          [UIImage imageNamed:@"coin_shimmer0005.png"],
                          [UIImage imageNamed:@"coin_shimmer0000.png"],
                          [UIImage imageNamed:@"coin_shimmer0000.png"],
                          [UIImage imageNamed:@"coin_shimmer0000.png"],
                          [UIImage imageNamed:@"coin_shimmer0000.png"],
                          [UIImage imageNamed:@"coin_shimmer0000.png"]];
        
        [self setAnimation:coin duration:2 forKey:kCoinAnimationKey];
        [self setAnimationToAnimationWithKey:kCoinAnimationKey];
        
    }
    return self;
}

@end
