//
//  GuardView.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"
#import "GuardView.h"


typedef enum {
    None,
    Up,
    Down,
    Left,
    Right
} GuardDirection;


@interface GuardView ()
@property (nonatomic, assign) BOOL patrolling;
@property (nonatomic, assign) CGFloat sightAngle;
@property (nonatomic, assign) CGFloat sightSpeed;
@property (nonatomic, assign) GuardDirection direction;
@end

static const CGFloat SIGHT_ARC = M_PI/2.5;
static const int SIGHT_RANGE = 190;

@implementation GuardView {
    Guard *_guard;
    BOOL _returningToPatrolStart;
    CGPoint _currentDestination;
    CGPoint _finalDestination;
    UIImageView *_sightImageView;
    GTMultiSpriteView *_sprite;
}

static NSString * const kGuardIdleFrontKey = @"kGuardIdleFrontKey";
static NSString * const kGuardIdleBackKey = @"kGuardIdleBackKey";
static NSString * const kGuardIdleSideKey = @"kGuardIdleSideKey";
static NSString * const kGuardWalkFrontKey = @"kGuardWalkFrontKey";
static NSString * const kGuardWalkBackKey = @"kGuardWalkBackKey";
static NSString * const kGuardWalkSideKey = @"kGuardWalkSideKey";


- (id)initWithGuard:(Guard *)guard delegate:(id<GuardMoveDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        _guard = guard;
        
        CGSize size = CGSizeMake(50, 50);
        CGPoint start = _guard.startPoint;
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.center = start;
        
        self.patrolling = YES;
        
        UIImage *sightImage = [self viewRangeImage:NO];
        _sightImageView = [[UIImageView alloc] initWithImage:sightImage];
        _sightImageView.center = CGPointMake(size.width/2, size.height/2);
        [self addSubview:_sightImageView];
        
        _returningToPatrolStart = YES;
        [self reachedDestination];
        
        NSArray *walkDown = @[[UIImage imageNamed:@"guard_walk_front0000"],
                            [UIImage imageNamed:@"guard_walk_front0001"],
                            [UIImage imageNamed:@"guard_walk_front0002"],
                            [UIImage imageNamed:@"guard_walk_front0003"],
                            [UIImage imageNamed:@"guard_walk_front0004"],
                            [UIImage imageNamed:@"guard_walk_front0005"],
                            [UIImage imageNamed:@"guard_walk_front0006"],
                            [UIImage imageNamed:@"guard_walk_front0007"]];
        
        NSArray *walkUp = @[[UIImage imageNamed:@"guard_walk_back0000"],
                              [UIImage imageNamed:@"guard_walk_back0001"],
                              [UIImage imageNamed:@"guard_walk_back0002"],
                              [UIImage imageNamed:@"guard_walk_back0003"],
                              [UIImage imageNamed:@"guard_walk_back0004"],
                              [UIImage imageNamed:@"guard_walk_back0005"],
                              [UIImage imageNamed:@"guard_walk_back0006"],
                              [UIImage imageNamed:@"guard_walk_back0007"]];
        
        NSArray *walkSide = @[[UIImage imageNamed:@"guard_walk_side0000"],
                            [UIImage imageNamed:@"guard_walk_side0001"],
                            [UIImage imageNamed:@"guard_walk_side0002"],
                            [UIImage imageNamed:@"guard_walk_side0003"],
                            [UIImage imageNamed:@"guard_walk_side0004"],
                            [UIImage imageNamed:@"guard_walk_side0005"],
                            [UIImage imageNamed:@"guard_walk_side0006"],
                            [UIImage imageNamed:@"guard_walk_side0007"]];
        
        NSArray *idleUp = @[[UIImage imageNamed:@"guard_idle_back"]];
        NSArray *idleDown = @[[UIImage imageNamed:@"guard_idle_front"]];
        NSArray *idleSide = @[[UIImage imageNamed:@"guard_idle_side"]];
        
        _sprite = [[GTMultiSpriteView alloc] initWithFrame:self.bounds];
        [self addSubview:_sprite];
        
        [_sprite setAnimation:walkDown duration:1.2 forKey:kGuardWalkFrontKey];
        [_sprite setAnimation:walkUp duration:1.2 forKey:kGuardWalkBackKey];
        [_sprite setAnimation:walkSide duration:0.6 forKey:kGuardWalkSideKey];
        [_sprite setAnimation:idleDown duration:1 forKey:kGuardIdleFrontKey];
        [_sprite setAnimation:idleUp duration:1 forKey:kGuardIdleBackKey];
        [_sprite setAnimation:idleSide duration:1 forKey:kGuardIdleSideKey];
        
        self.sightAngle = self.currentAngle;    
    }
    return self;
}


- (void)updateAnimation {
    BOOL moving = !(CGPointEqualToPoint(_guard.startPoint, _guard.endPoint) && CGPointEqualToPoint(_guard.startPoint, self.center)) && !self.paused;
    
    if (moving) {
        switch (_direction) {
            case Up:
                [_sprite setAnimationToAnimationWithKey:kGuardWalkBackKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
            case Down:
                [_sprite setAnimationToAnimationWithKey:kGuardWalkFrontKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
            case Left:
                [_sprite setAnimationToAnimationWithKey:kGuardWalkSideKey];
                _sprite.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
                break;
            case Right:
                [_sprite setAnimationToAnimationWithKey:kGuardWalkSideKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
        }

    } else {
        switch (_direction) {
            case Up:
                [_sprite setAnimationToAnimationWithKey:kGuardIdleBackKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
            case Down:
                [_sprite setAnimationToAnimationWithKey:kGuardIdleFrontKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
            case Left:
                [_sprite setAnimationToAnimationWithKey:kGuardIdleSideKey];
                _sprite.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
                break;
            case Right:
                [_sprite setAnimationToAnimationWithKey:kGuardIdleSideKey];
                _sprite.transform = CGAffineTransformIdentity;
                break;
        }
    }
    
}


- (void)move:(NSTimeInterval)moveTime {
    // Some guards just don't patrol
    if (!(_patrolling && CGPointEqualToPoint(_guard.startPoint, _guard.endPoint) && CGPointEqualToPoint(_guard.startPoint, self.center))) {
        [super move:moveTime];
    }
    
    if (_sightAngle != self.currentAngle) {
        
        CGFloat diff1 = self.currentAngle - _sightAngle;
        CGFloat diff2 = (2*M_PI - fabsf(diff1)) * (diff1 > 0 ? -1 : 1);

        CGFloat rotateDiff;
        BOOL positiveRotate;
        if (fabsf(diff1) < fabsf(diff2)) {
            rotateDiff = diff1;
            positiveRotate = diff1 > 0;
        } else {
            rotateDiff = diff2;
            positiveRotate = diff2 > 0;
        }
        
        CGFloat movement = _sightSpeed * moveTime;
        if (fabsf(rotateDiff) <= fabsf(movement)) {
            self.sightAngle = self.currentAngle;
        } else {
            self.sightAngle += movement * (positiveRotate ? 1 : -1);
        }
    }
}


- (void)beLuredToLocation:(CGPoint)location {
    if ([self attemptToSetDestination:location maxDepth:500]) {
        self.patrolling = NO;
    }
}


- (BOOL)tryToSpot:(CGPoint)location {
    CGFloat xDist = location.x - self.center.x;
    CGFloat yDist = location.y - self.center.y;
    
    double distance = sqrt(pow(xDist, 2.0) + pow(yDist, 2.0));
    
    if (fabsf(distance) < SIGHT_RANGE) {
        CGFloat angleOfSight = self.sightAngle;
        CGFloat angleToDestination = atan2(yDist, xDist);
        
        if (angleToDestination < 0) {
            angleToDestination = angleToDestination + 2*M_PI;
        }
        if (angleToDestination > 2*M_PI) {
            angleToDestination = angleToDestination - 2*M_PI;
        }
        
        if (fabsf(angleToDestination - angleOfSight) <= SIGHT_ARC / 2) {
            [self catchEm];
            return YES;
        }
    }
    return NO;
}


#pragma mark -


- (BOOL)reachedDestination {
    BOOL setNewDest = [super reachedDestination];
    
    if (!setNewDest) {
        // If we just finished a patrol, do it in reverse.
        if (_patrolling) {
            CGPoint desiredDest = (_returningToPatrolStart ? _guard.endPoint : _guard.startPoint);
            [self attemptToSetDestination:desiredDest maxDepth:INFINITY];
            _returningToPatrolStart = !_returningToPatrolStart;
            
            if (CGPointEqualToPoint(self.center, _guard.startPoint) && CGPointEqualToPoint(_guard.startPoint, _guard.endPoint)) {
                [self updateAnimation];
                self.currentAngle = _guard.initialAngle;
            }
            
        // Otherwise return to patrolling where you left off
        } else {
            self.paused = YES;
            double delayInSeconds = 0.75;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.paused = NO;
                
                if (CGPointEqualToPoint(self.center, self.currentDestination)) {
                    self.patrolling = YES;
                    CGPoint desiredDest = (!_returningToPatrolStart ? _guard.endPoint : _guard.startPoint);
                    [self attemptToSetDestination:desiredDest maxDepth:INFINITY];
                }
            });
        }
        _sightSpeed = 1.5*M_PI;
    } else {
        _sightSpeed = 2.5*M_PI;
    }

    
    return YES;
}


- (UIImage *)viewRangeImage:(BOOL)caught {
    CGPoint p1 = CGPointMake(SIGHT_RANGE * cos(M_PI/2 - SIGHT_ARC/2), SIGHT_RANGE * sin(M_PI/2 - SIGHT_ARC/2));
    CGPoint p2 = CGPointMake(SIGHT_RANGE * cos(M_PI/2 + SIGHT_ARC/2), SIGHT_RANGE * sin(M_PI/2 + SIGHT_ARC/2));
    
    int width = p1.x - p2.x;
    p1.x += width/2;
    p2.x += width/2;
    
    int height = fabsf(p1.y);
    p1.y += height;
    p2.y += height;
    
    CGPoint p0 = CGPointMake(width/2, height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p0];
    [path addLineToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p0];
    
    UIImage *glyphImage;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height*2));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, (caught ? [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor : [[UIColor blueColor] colorWithAlphaComponent:0.2].CGColor));
    
    [path fill];
    
    glyphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return glyphImage;
}


- (void)catchEm {
    _sightImageView.image = [self viewRangeImage:YES];
}


#pragma mark -


- (void)setPatrolling:(BOOL)patrolling {
    if (patrolling != _patrolling) {
        _patrolling = patrolling;
    }
    self.speed = (patrolling ? 50 : 130);
}


- (void)setSightAngle:(CGFloat)sightAngle {
    if (sightAngle < 0) {
        sightAngle = sightAngle + 2*M_PI;
    }
    if (sightAngle > 2*M_PI) {
        sightAngle = sightAngle - 2*M_PI;
    }
    
    if (sightAngle != _sightAngle) {
        _sightAngle = sightAngle;
        
        CGFloat angleOfSightView = self.sightAngle - M_PI/2;
        _sightImageView.transform = CGAffineTransformMakeRotation(angleOfSightView);
    }
    
    if (_sightAngle > M_PI*1.3 && _sightAngle < (1.7*M_PI)) {
        self.direction = Up;
    } else if (_sightAngle < M_PI*0.7 && _sightAngle > M_PI*0.3) {
        self.direction = Down;
    } else if (_sightAngle > M_PI/2 && _sightAngle < M_PI*1.5) {
        self.direction = Left;
    } else {
        self.direction = Right;
    }
}


- (void)setDirection:(GuardDirection)direction {
    if (direction != _direction) {
        _direction = direction;
        [self updateAnimation];
    }
}


- (void)setPaused:(BOOL)paused {
    [super setPaused:paused];
    [self updateAnimation];
}


@end
