//
//  DoorNavigatingView.m
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "DoorNavigatingView.h"

@implementation DoorNavigatingView


- (id)initWithDelegate:(id<GuardMoveDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        // TODO create some sort of initial angle for stationary guards.
        self.currentAngle = M_PI/2;
    }
    return self;
}


- (void)move:(NSTimeInterval)moveTime {
    CGPoint center = self.center;
    
    if (_paused) {
        return;
    }
    
    int distance = _speed*moveTime;
    
    CGFloat yDist = _currentDestination.y - center.y;
    CGFloat xDist = _currentDestination.x - center.x;
    CGFloat angleToDestination = atan2(yDist, xDist);
    
    self.currentAngle = angleToDestination;
    
    CGFloat dx = distance * cos(angleToDestination);
    CGFloat dy = distance * sin(angleToDestination);
    
    CGFloat x = center.x + dx;
    CGFloat y = center.y + dy;
    
    BOOL reached;
    if (fabsf(dx) >= fabsf(xDist)) {
        x = _currentDestination.x;
        reached = YES;
    }
    
    if (fabsf(dy) >= fabsf(yDist)) {
        y = _currentDestination.y;
    } else {
        reached = NO;
    }
    
    self.center = CGPointMake(x, y);
    
    if (reached) {
        [self reachedDestination];
    }
}


- (BOOL)reachedDestination {
    if (!CGPointEqualToPoint(_currentDestination, _finalDestination)) {
        [self attemptToSetDestination:_finalDestination maxDepth:INFINITY];
        [self.delegate navigatingView:self reachedIntermediaryDestination:_currentDestination nextDest:_currentDestination];
        return YES;
    } else {
        [self.delegate navigatingView:self reachedFinalDestination:_finalDestination];
        return NO;
    }
}


- (BOOL)attemptToSetDestination:(CGPoint)attemptedDestination maxDepth:(int)maxDepth {
    CGPoint intermediary;
    BOOL canReach = [self.delegate canReachDest:attemptedDestination fromLocation:self.center maxDepth:maxDepth nextLoc:&intermediary];
    if (canReach) {
        _finalDestination = attemptedDestination;
        self.currentDestination = intermediary;
        return YES;
    }
    return NO;
}


- (void)setCurrentDestination:(CGPoint)currentDestination {
    _currentDestination = currentDestination;
    
    CGFloat yDist = _currentDestination.y - self.center.y;
    CGFloat xDist = _currentDestination.x - self.center.x;
    CGFloat angleToDestination = atan2(yDist, xDist);
    self.currentAngle = angleToDestination;
    
}


- (void)setCurrentAngle:(CGFloat)currentAngle {
    if (currentAngle < 0) {
        currentAngle = currentAngle + 2*M_PI;
    }
    if (currentAngle > 2*M_PI) {
        currentAngle = currentAngle - 2*M_PI;
    }
    _currentAngle = currentAngle;
}


@end
