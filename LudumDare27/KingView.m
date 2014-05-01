//
//  KingView.m
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "KingView.h"

@implementation KingView {
    BOOL _soulless;
}

static NSString * const kKingIdleDownKey = @"kKingIdleDownKey";
static NSString * const kKingIdleUpKey = @"kKingIdleUpKey";
static NSString * const kKingRunUpKey = @"kKingRunUpKey";
static NSString * const kKingRunDownKey = @"kKingRunDownKey";
static NSString * const kKingSoullessUpKey = @"kKingSoullessUpKey";
static NSString * const kKingSoullessDownKey = @"kKingSoullessDownKey";


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *runDown = @[[UIImage imageNamed:@"solomon_run_down0000.png"],
                            [UIImage imageNamed:@"solomon_run_down0001.png"],
                            [UIImage imageNamed:@"solomon_run_down0002.png"],
                            [UIImage imageNamed:@"solomon_run_down0003.png"],
                            [UIImage imageNamed:@"solomon_run_down0004.png"],
                            [UIImage imageNamed:@"solomon_run_down0005.png"],
                            [UIImage imageNamed:@"solomon_run_down0006.png"],
                            [UIImage imageNamed:@"solomon_run_down0007.png"]];
        
        NSArray *runUp = @[[UIImage imageNamed:@"solomon_run_up0000.png"],
                             [UIImage imageNamed:@"solomon_run_up0001.png"],
                             [UIImage imageNamed:@"solomon_run_up0002.png"],
                             [UIImage imageNamed:@"solomon_run_up0003.png"],
                             [UIImage imageNamed:@"solomon_run_up0004.png"],
                             [UIImage imageNamed:@"solomon_run_up0005.png"],
                             [UIImage imageNamed:@"solomon_run_up0006.png"],
                             [UIImage imageNamed:@"solomon_run_up0007.png"]];

        NSArray *idleUp = @[[UIImage imageNamed:@"solomon_idle_up0000.png"],
                            [UIImage imageNamed:@"solomon_idle_up0001.png"],
                            [UIImage imageNamed:@"solomon_idle_up0002.png"],
                            [UIImage imageNamed:@"solomon_idle_up0003.png"]];

        NSArray *idleDown = @[[UIImage imageNamed:@"solomon_idle_down0000.png"],
                            [UIImage imageNamed:@"solomon_idle_down0001.png"],
                            [UIImage imageNamed:@"solomon_idle_down0002.png"],
                            [UIImage imageNamed:@"solomon_idle_down0003.png"]];
        
        NSArray *soullessUp = @[[UIImage imageNamed:@"solomon_soulless_up0000"],
                                [UIImage imageNamed:@"solomon_soulless_up0001"]];
        
        NSArray *soullessDown = @[[UIImage imageNamed:@"solomon_soulless_down0000"],
                                [UIImage imageNamed:@"solomon_soulless_down0001"]];
        
        [self setAnimation:runDown duration:1.2 forKey:kKingRunDownKey];
        [self setAnimation:runUp duration:1.2 forKey:kKingRunUpKey];
        [self setAnimation:idleDown duration:0.6 forKey:kKingIdleDownKey];
        [self setAnimation:idleUp duration:0.6 forKey:kKingIdleUpKey];
        [self setAnimation:soullessDown duration:1 forKey:kKingSoullessDownKey];
        [self setAnimation:soullessUp duration:1 forKey:kKingSoullessUpKey];
        
        [self reachedDestination];
        
        [self updateAnimation];
        
        self.speed = 120;
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
    if (_soulless) return;
    
    if (_moving && _facingUp) {
        [self setAnimationToAnimationWithKey:kKingRunUpKey];
    } else if(_moving && !_facingUp) {
        [self setAnimationToAnimationWithKey:kKingRunDownKey];
    } else if (!_moving && _facingUp) {
        [self setAnimationToAnimationWithKey:kKingIdleUpKey];
    } else if (!_moving && !_facingUp) {
        [self setAnimationToAnimationWithKey:kKingIdleDownKey];
    }
}


- (void)goSoulless:(BOOL)soulless {
    _soulless = soulless;
    if (soulless) {
        if (_facingUp) {
            [self setAnimationToAnimationWithKey:kKingSoullessUpKey];
        } else {
            [self setAnimationToAnimationWithKey:kKingSoullessDownKey];
        }
    } else {
        [self updateAnimation];
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
