//
//  SpiritView.m
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "SpiritView.h"

@implementation SpiritView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self reachedDestination];
        
        self.backgroundColor = [UIColor cyanColor];
        
        self.speed = 220;
    }
    return self;
}



@end
