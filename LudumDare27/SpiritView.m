//
//  SpiritView.m
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "SpiritView.h"

@implementation SpiritView

static NSString * const kSoulIdleDownKey = @"kSoulIdleDownKey";
static NSString * const kSoulIdleUpKey = @"kSoulIdleUpKey";
static NSString * const kSoulRunUpKey = @"kSoulRunUpKey";
static NSString * const kSoulRunDownKey = @"kSoulRunDownKey";


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *runDown = @[[UIImage imageNamed:@"soul_move_down0000.png"],
                             [UIImage imageNamed:@"soul_move_down0001.png"],
                             [UIImage imageNamed:@"soul_move_down0002.png"],
                             [UIImage imageNamed:@"soul_move_down0003.png"]];
        
        NSArray *runUp = @[[UIImage imageNamed:@"soul_move_up0000.png"],
                           [UIImage imageNamed:@"soul_move_up0001.png"],
                           [UIImage imageNamed:@"soul_move_up0002.png"],
                           [UIImage imageNamed:@"soul_move_up0003.png"]];
        
        NSArray *idleDown = @[[UIImage imageNamed:@"soul_idle_down0000.png"],
                              [UIImage imageNamed:@"soul_idle_down0001.png"],
                              [UIImage imageNamed:@"soul_idle_down0002.png"],
                              [UIImage imageNamed:@"soul_idle_down0003.png"]];
        
        NSArray *idleUp = @[[UIImage imageNamed:@"soul_idle_up0000.png"],
                            [UIImage imageNamed:@"soul_idle_up0001.png"],
                            [UIImage imageNamed:@"soul_idle_up0002.png"],
                            [UIImage imageNamed:@"soul_idle_up0003.png"]];
        
        
        [self setAnimation:runDown duration:1.2 forKey:kSoulRunDownKey];
        [self setAnimation:runUp duration:1.2 forKey:kSoulRunUpKey];
        [self setAnimation:idleDown duration:0.6 forKey:kSoulIdleDownKey];
        [self setAnimation:idleUp duration:0.6 forKey:kSoulIdleUpKey];
        
        [self reachedDestination];
        
        self.speed = 220;
        
        [self updateAnimation];
    }
    return self;
}


- (void)setFacingLeft:(BOOL)facingLeft {
    if (facingLeft != _facingLeft) {
        _facingLeft = facingLeft;
        if (facingLeft) {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
    }
}


- (void)setFacingUp:(BOOL)facingUp {
    if (facingUp != _facingUp) {
        _facingUp = facingUp;
        [self updateAnimation];
    }
}


- (void)setMoving:(BOOL)moving {
    if (moving != _moving) {
        _moving = moving;
        [self updateAnimation];
    }
}


- (void)updateAnimation {
    if (_moving && _facingUp) {
        [self setAnimationToAnimationWithKey:kSoulRunUpKey];
    } else if(_moving && !_facingUp) {
        [self setAnimationToAnimationWithKey:kSoulRunDownKey];
    } else if (!_moving && _facingUp) {
        [self setAnimationToAnimationWithKey:kSoulIdleUpKey];
    } else if (!_moving && !_facingUp) {
        [self setAnimationToAnimationWithKey:kSoulIdleDownKey];
    }
}



- (void)setCenter:(CGPoint)center {
    center.y -= self.frame.size.height/2;
    [super setCenter:center];
}


- (CGPoint)center {
    CGPoint point = [super center];
    point.y += self.frame.size.height/2;
    return point;
}



@end
