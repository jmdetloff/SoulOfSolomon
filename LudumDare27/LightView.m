//
//  LightView.m
//  LudumDare27
//
//  Created by John Detloff on 8/25/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "LightView.h"

@implementation LightView

static NSString * const kLitAnimationKey = @"kLitAnimationKey";
static NSString * const kUnlitAnimationKey = @"kUnlitAnimationKey";


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        NSArray *litTorch = @[[UIImage imageNamed:@"torch_lit0000.png"],
                             [UIImage imageNamed:@"torch_lit0001.png"],
                             [UIImage imageNamed:@"torch_lit0002.png"],
                              [UIImage imageNamed:@"torch_lit0003.png"]];
        
        NSArray *unlitTorch = @[[UIImage imageNamed:@"torch_unlit.png"]];
        
        [self setAnimation:litTorch duration:0.5 forKey:kLitAnimationKey];
        [self setAnimation:unlitTorch duration:1.2 forKey:kUnlitAnimationKey];
        
        [self setAnimationToAnimationWithKey:kLitAnimationKey];
        
    }
    return self;
}


- (void)setLit:(BOOL)lit {
    if (lit) {
        [self setAnimationToAnimationWithKey:kLitAnimationKey];
    } else {
        [self setAnimationToAnimationWithKey:kUnlitAnimationKey];
    }
}



@end
