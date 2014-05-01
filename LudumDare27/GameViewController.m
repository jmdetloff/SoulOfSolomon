//
//  GameViewController.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "PathFinder.h"
#import "GuardView.h"
#import "WallView.h"
#import "Level.h"
#import "GameViewController.h"
#import "KingView.h"
#import "SpiritView.h"
#import "KeyView.h"
#import "AppDelegate.h"
#import "LightView.h"
#import "BellView.h"
#import "CoinViews.h"


@interface GameViewController () <GuardMoveDelegate, PathFinderDelegate>
@end


@implementation GameViewController {
    Level *_level;
    NSTimer *_timer;
    NSMutableArray *_guardViews;
    NSMutableArray *_wallViews;
    KingView *_kingBody;
    PathFinder *_finder;
    NSMutableArray *_doorNodes;
    NSMutableArray *_keyViews;
    NSMutableArray *_gottenKeys;
    NSMutableArray *_noiseMakerViews;
    NSMutableArray *_lightViews;
    NSMutableArray *_darkViews;
    NSMutableArray *_coinViews;
    NSMutableArray *_bigCoinViews;
    
    BOOL _spiritMode;
    BOOL _flewAway;
    
    SpiritView *_spiritView;
    
    UIButton *_spiritButton;
    
    NoiseMaker *_onMaker;
    UIView *_onLight;
    
    UIAlertView *_loseAlertView;
    UIAlertView *_winAlertView;
    
    BOOL _debug;
    
    NSTimer *_spiritTimer;
    int _spiritCount;
}


- (id)initWithLevel:(Level *)level {
    self = [super init];
    if (self) {
        _level = level;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _wallViews = [[NSMutableArray alloc] init];
    _doorNodes = [[NSMutableArray alloc] init];
    _finder = [[PathFinder alloc] init];
    _finder.delegate = self;
    
    for (Wall *wall in _level.walls) {

        CGRect wallFrame;
        if (wall.vertical) {
            CGFloat xStart = wall.startPoint.x - 16;
            CGFloat yStart = wall.startPoint.y;
            
            wallFrame = CGRectMake(xStart, yStart, 32, (wall.endPoint.y - wall.startPoint.y));
        } else {
            
            BOOL leftWall = wall.startPoint.x != 0;
            BOOL rightWall = wall.endPoint.x != 1024;
            
            CGFloat xStart = wall.startPoint.x + (leftWall ? 16 : 0);
            CGFloat width = wall.endPoint.x - wall.startPoint.x - (leftWall ? 16 : 0) - (rightWall ? 16 : 0);
            
            wallFrame = CGRectMake(xStart, wall.startPoint.y - 96, width, 96);
        }
        
        WallView *wallView = [[WallView alloc] initWithFrame:wallFrame wall:wall];
        [_wallViews addObject:wallView];
        
        [wallView.doorViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DoorNode *node = [[DoorNode alloc] init];
            node.door = [wall.doors objectAtIndex:idx];
            
            CGPoint doorLocation = (wall.vertical ? CGPointMake(wall.startPoint.x, wall.startPoint.y + (wall.endPoint.y - wall.startPoint.y)*node.door.location/100)
                                    : CGPointMake(wall.startPoint.x + (wall.endPoint.x - wall.startPoint.x)*node.door.location/100, wall.startPoint.y));
            
            node.location = doorLocation;
            node.wall = wall;
            [_doorNodes addObject:node];
        }];
    }
    
    _guardViews = [[NSMutableArray alloc] init];
    
    for (Guard *guard in _level.guards) {
        GuardView *guardView = [[GuardView alloc] initWithGuard:guard delegate:self];
        guardView.currentAngle = guard.initialAngle;
        [_guardViews addObject:guardView];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(0.02) target:self selector:@selector(move) userInfo:nil repeats:YES];
    
    _kingBody = [[KingView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _kingBody.delegate = self;
    _kingBody.center = _level.kingStartPosition;
    [_kingBody attemptToSetDestination:_level.kingStartPosition maxDepth:INFINITY];
    [self.view addSubview:_kingBody];
    
    for (GuardView *view in _guardViews) {
        [self.view addSubview:view];
    }

    
    _keyViews = [NSMutableArray array];
    
    [_level.keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Key *key = (Key *)obj;
        
        UIView *keyView = key.display;
        keyView.tag = idx;
        keyView.center = key.location;
        [self.view addSubview:keyView];
        
        [_keyViews addObject:keyView];
    }];
 
    _gottenKeys = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stone_floor"]];
    
    _spiritButton = [[UIButton alloc] initWithFrame:CGRectMake(925, 5, 75, 50)];
    _spiritButton.backgroundColor = [UIColor whiteColor];
    [_spiritButton setTitle:@"10" forState:UIControlStateNormal];
    [_spiritButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_spiritButton addTarget:self action:@selector(spiritModeActivate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_spiritButton];
    
    _spiritView = [[SpiritView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _spiritView.hidden = YES;
    _spiritView.delegate = self;
    [self.view addSubview:_spiritView];
    
    _noiseMakerViews = [[NSMutableArray alloc] init];
    
    [_level.noiseMakers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NoiseMaker *maker = (NoiseMaker *)obj;
        
        BellView *makerView = maker.display;
        makerView.center = maker.location;
        [self.view addSubview:makerView];
        
        [_noiseMakerViews addObject:makerView];
    }];
    
    _lightViews = [[NSMutableArray alloc] init];
    _darkViews = [[NSMutableArray alloc] init];
    
    for (Light *light in _level.lights) {
        LightView *lightView = [[LightView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        lightView.center = light.location;
        [self.view addSubview:lightView];
        
        UIView *darkView = [[UIView alloc] initWithFrame:light.zone];
        darkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        darkView.hidden = YES;
        [self.view addSubview:darkView];
        
        [_lightViews addObject:lightView];
        [_darkViews addObject:darkView];
    }
    
    _coinViews = [[NSMutableArray alloc] init];
    
    for (WallView *view in _wallViews) {
        [self.view addSubview:view];
    }
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(spiritModeActivate:)];
    [self.view addGestureRecognizer:recognizer];
    
    _bigCoinViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < _level.numCoins; i++) {
        [self addCoinView];
    }
    
    _debug = NO;
}


- (void)addCoinView {
    UIImageView *bigCoin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin_big"]];
    bigCoin.center = CGPointMake(890 - [_bigCoinViews count]*60, 33);
    [self.view addSubview:bigCoin];
    
    [_bigCoinViews addObject:bigCoin];
}

#pragma mark -


- (void)move {
    [_kingBody move:0.02];
    [_spiritView move:0.02];
    
    if (CGRectContainsPoint(_level.winZone, _kingBody.center)) {
        [self win];
        return;
    }
    
    __block BOOL kingInDark = NO;
    [_darkViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *dark = (UIView *)obj;
        if (!dark.hidden && CGRectContainsPoint(dark.frame, _kingBody.center)) {
            kingInDark = YES;
            *stop = YES;
        }
    }];
    
    for (GuardView *gv in _guardViews) {
        [gv move:0.02];
        
        __block int lightOutIndex = -1;
        [_darkViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *dark = (UIView *)obj;
            if (!dark.hidden && CGRectContainsPoint(dark.frame, gv.center)) {
                lightOutIndex = idx;
                *stop = YES;
            }
        }];
        
        if (lightOutIndex != -1) {
            UIView *lightView = _lightViews[lightOutIndex];
            [gv beLuredToLocation:lightView.center distance:INFINITY];
        }
        
        [_lightViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LightView *lightView = (LightView *)obj;
            double distance = sqrt(pow((gv.center.x - lightView.center.x), 2.0) + pow((gv.center.y - lightView.center.y), 2.0));
            if (distance < 30) {
                UIView *darkView = _darkViews[idx];
                darkView.hidden = YES;
                [lightView setLit:YES];
            }
        }];
        
        if (![self wallIntersectionBetweenPointA:_kingBody.center pointB:gv.center] && !kingInDark) {
            BOOL spotted = [gv tryToSpot:_kingBody.center];
            if (spotted) {
                [gv tryToSpot:_kingBody.center];
            }
            if (spotted && !_debug) {
                _loseAlertView = [[UIAlertView alloc] initWithTitle:@"You've been spotted!" message:@"A traitorous houndbeast tears you royal limb from limb." delegate:self cancelButtonTitle:@"Try again?" otherButtonTitles:nil, nil];
                [_loseAlertView show];
                [_timer invalidate];
                [_spiritTimer invalidate];
            }
        }
        
        NSMutableArray *removedCoins = [NSMutableArray array];
        
        for (UIView *stallView in _coinViews) {
            double distance = sqrt(pow((gv.center.x - stallView.center.x), 2.0) + pow((gv.center.y - stallView.center.y), 2.0));
            if (distance < 45) {
                gv.paused = YES;
                [stallView removeFromSuperview];
                [removedCoins addObject:stallView];
                [self addCoinView];
                double delayInSeconds = 1.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    gv.paused = NO;
                });
            }
        }
        
        [_coinViews removeObjectsInArray:removedCoins];
    }
    
    if (_spiritMode) {
        double distance = sqrt(pow((_spiritView.center.x - _kingBody.center.x), 2.0) + pow((_spiritView.center.y - _kingBody.center.y), 2.0));
        if (distance < 30 && _flewAway) {
            _spiritMode = NO;
            _spiritView.hidden = YES;
            [_spiritButton setTitle:@"10" forState:UIControlStateNormal];
            [_spiritTimer invalidate];
            [_kingBody goSoulless:NO];
        } else if (distance > 30) {
            _flewAway = YES;
        }
        
        __block BOOL onAnyMaker = NO;
        [_noiseMakerViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BellView *makerView = (BellView *)obj;
            double distance = sqrt(pow((_spiritView.center.x - makerView.center.x), 2.0) + pow((_spiritView.center.y - makerView.center.y), 2.0));
            if (distance < 30) {
                onAnyMaker = YES;
                NoiseMaker *maker = _level.noiseMakers[idx];
                if (maker == _onMaker) {
                    return;
                }
                _onMaker = maker;
                [makerView ring];
                if (maker.activateTime > 0) {
                    double delayInSeconds = maker.activateTime;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self lureGuardsToLocation:maker.location];
                    });
                } else {
                    [self lureGuardsToLocation:maker.location];
                }
            }
        }];
        
        if (!onAnyMaker) {
            _onMaker = nil;
        }
        
        __block BOOL onAnyLight = NO;
        [_lightViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LightView *lightView = (LightView *)obj;
            double distance = sqrt(pow((_spiritView.center.x - lightView.center.x), 2.0) + pow((_spiritView.center.y - lightView.center.y), 2.0));
            if (distance < 30) {
                onAnyLight = YES;
                if (_onLight == lightView) {
                    return;
                }
                _onLight = lightView;
                UIView *darkView = _darkViews[idx];
                darkView.hidden = NO;
                [lightView setLit:NO];
            }
        }];
        
        if (!onAnyLight) {
            _onLight = nil;
        }
        
        NSMutableArray *removedCoins = [NSMutableArray array];
        for (CoinViews *coin in _coinViews) {
            double distance = sqrt(pow((coin.center.x - _spiritView.center.x), 2.0) + pow((coin.center.y - _spiritView.center.y), 2.0));
            if (distance < 30 && coin.tag == 0) {
                [removedCoins addObject:coin];
                [coin removeFromSuperview];
                [self addCoinView];
            }
        }
        [_coinViews removeObjectsInArray:removedCoins];
        
        
    } else {
        for (KeyView *keyView in _keyViews) {
            double distance = sqrt(pow((keyView.center.x - _kingBody.center.x), 2.0) + pow((keyView.center.y - _kingBody.center.y), 2.0));
            if (distance < 30) {
                [keyView removeFromSuperview];
                [_gottenKeys addObject:[_level.keys objectAtIndex:keyView.tag]];
                
                for (WallView *wallView in _wallViews) {
                    [wallView gotKey:keyView];
                }
            }
        }
        for (WallView *wallView in _wallViews) {
            if (CGRectIntersectsRect(wallView.frame, _kingBody.frame)) {
                if (CGRectGetMaxY(wallView.frame) > CGRectGetMaxY(_kingBody.frame)) {
                    [self.view insertSubview:wallView aboveSubview:_kingBody];
                } else {
                    [self.view insertSubview:wallView belowSubview:_kingBody];
                }
            }
        }
    }
    
    for (CoinViews *coin in _coinViews) {
        if (!_spiritMode) {
            coin.tag = 0;
            continue;
        }
        
        double distance = sqrt(pow((coin.center.x - _spiritView.center.x), 2.0) + pow((coin.center.y - _spiritView.center.y), 2.0));
        if (distance > 30) {
            coin.tag = 0;
        }
    }
}


- (void)lureGuardsToLocation:(CGPoint)loc {
    for (GuardView *guardView in _guardViews) {
        [guardView beLuredToLocation:loc distance:600];
    }
}


#pragma mark -


- (void)spiritModeActivate:(UIGestureRecognizer *)recognizer {
    if (_spiritMode) return;
    
    CGPoint location = [recognizer locationInView:self.view];
    
    _spiritTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(spiritCount) userInfo:nil repeats:YES];
    _spiritCount = 10;
    
    [_spiritButton setTitle:[NSString stringWithFormat:@"%i", _spiritCount] forState:UIControlStateNormal];
    
    _spiritButton.enabled = NO;
    _spiritMode = YES;
    _flewAway = NO;
    
    _spiritView.center = _kingBody.center;
    [_spiritView attemptToSetDestination:_kingBody.center maxDepth:INFINITY];
    _spiritView.hidden = NO;
    
    _spiritView.facingLeft = NO;
    _spiritView.facingUp = NO;
    _spiritView.moving = NO;
    
    [_kingBody attemptToSetDestination:_kingBody.center maxDepth:INFINITY];
    [_kingBody goSoulless:YES];
    
    [_spiritView attemptToSetDestination:location maxDepth:INFINITY];
    _spiritView.moving = YES;
    _spiritView.facingLeft =_spiritView.currentDestination.x < _spiritView.center.x;
    _spiritView.facingUp = _spiritView.currentDestination.y < _spiritView.center.y;
}


- (void)spiritCount {
    _spiritCount--;
    [_spiritButton setTitle:[NSString stringWithFormat:@"%i", _spiritCount] forState:UIControlStateNormal];
    
    if (_spiritCount == 0 && !_debug) {
        [_spiritTimer invalidate];
        
        _loseAlertView = [[UIAlertView alloc] initWithTitle:@"Out of time!" message:@"The bond between spirit and flesh is severed! You're doomed to wander your lonely dungeons forever, a pale shadow of your former regal glory." delegate:self cancelButtonTitle:@"Try again?" otherButtonTitles:nil, nil];
        [_loseAlertView show];
        [_timer invalidate];
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    if (!_spiritMode) {
        if (!CGPointEqualToPoint(_kingBody.center, loc)) {
            [_kingBody attemptToSetDestination:loc maxDepth:INFINITY];
            if (!CGPointEqualToPoint(_kingBody.center, _kingBody.currentDestination)) {
                _kingBody.moving = YES;
            }
            _kingBody.facingLeft = _kingBody.currentDestination.x < _kingBody.center.x;
            _kingBody.facingUp = _kingBody.currentDestination.y < _kingBody.center.y;
        }
    } else {
        
        CGPoint coinPoint = CGPointMake(_spiritView.center.x, _spiritView.center.y - _spiritView.frame.size.height/2);
        double distance = sqrt(pow((loc.x - coinPoint.x), 2.0) + pow((loc.y - coinPoint.y), 2.0));
        if (distance < 40 && [_bigCoinViews count] > 0) {
            CoinViews *coin = [[CoinViews alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            coin.center = loc;
            coin.tag = 1;
            [self.view insertSubview:coin atIndex:0];
            [_coinViews addObject:coin];
            
            [[_bigCoinViews lastObject] removeFromSuperview];
            [_bigCoinViews removeLastObject];
            
        } else {
            [_spiritView attemptToSetDestination:loc maxDepth:INFINITY];
            _spiritView.moving = YES;
            _spiritView.facingLeft =_spiritView.currentDestination.x < _spiritView.center.x;
            _spiritView.facingUp = _spiritView.currentDestination.y < _spiritView.center.y;
        }
    }

    
//    NSLog(@"%f %f", loc.x, loc.y);
    
//    for (GuardView *guardView in _guardViews) {
//        [guardView beLuredToLocation:loc];
////        if (![self wallIntersectionBetweenPointA:loc pointB:guardView.center]) {
////            [guardView tryToSpot:loc];
////        }
//    }
}



#pragma mark - pathfinding



- (void)navigatingView:(DoorNavigatingView *)view reachedIntermediaryDestination:(CGPoint)dest nextDest:(CGPoint)nextDest {
    if (view == _kingBody) {
        _kingBody.moving = YES;
        _kingBody.facingLeft = nextDest.x < _kingBody.center.x;
        _kingBody.facingUp = nextDest.y < _kingBody.center.y;
    }
    if (view == _spiritView) {
        _spiritView.moving = YES;
        _spiritView.facingLeft = nextDest.x < _spiritView.center.x;
        _spiritView.facingUp = nextDest.y < _spiritView.center.y;
    }
}


- (void)navigatingView:(DoorNavigatingView *)view reachedFinalDestination:(CGPoint)dest {
    if (view == _kingBody) {
        _kingBody.moving = NO;
    }
    if (view == _spiritView) {
        _spiritView.moving = NO;
    }
}


- (BOOL)navigatingView:(DoorNavigatingView *)view canReachDest:(CGPoint)dest fromLocation:(CGPoint)loc maxDepth:(int)maxDepth nextLoc:(CGPoint *)nextLoc {
    NSMutableArray *nodePath = [_finder searchPathFromPoint:loc toPoint:dest nodes:_doorNodes maxDepth:maxDepth locks:(view != _spiritView)];
    if ([nodePath count] == 0) {
        return NO;
    }
    
    *nextLoc = ((DoorNode *)[nodePath objectAtIndex:0]).location;
    return YES;
}


- (BOOL)nodeA:(DoorNode *)nodeA isAdjacentToNodeB:(DoorNode *)nodeB locks:(BOOL)locks {
    if (locks && ((nodeA.door.key != nil && ![_gottenKeys containsObject:nodeA.door.key]) || (nodeB.door.key != nil && ![_gottenKeys containsObject:nodeB.door.key]))) {
        return NO;
    }
    
    if (nodeA.wall == nodeB.wall && nodeA.wall != nil) {
        return YES;
    }
    
    return ![self wallIntersectionBetweenPointA:nodeA.location pointB:nodeB.location];
}


- (BOOL)wallIntersectionBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    for (WallView *wallView in _wallViews) {
        Wall *wall = wallView.wall;
        
        CGFloat intX;
        CGFloat intY;
        BOOL wallIntersection = get_line_intersection(pointA.x, pointA.y,
                                                      pointB.x, pointB.y,
                                                      wall.startPoint.x, wall.startPoint.y,
                                                      wall.endPoint.x, wall.endPoint.y,
                                                      &intX, &intY);
        if (wallIntersection) {
            CGPoint intersectionPoint = CGPointMake(intX, intY);
            if ((fabsf(pointA.x - intersectionPoint.x) < 0.1 && fabsf(pointA.y - intersectionPoint.y) < 0.1 )|| (fabsf(pointB.x - intersectionPoint.x) < 0.1 && fabsf(pointB.y - intersectionPoint.y) < 0.1)) {
                continue;
            }
            return YES;
        }
    }
    return NO;
}


BOOL get_line_intersection(CGFloat p0_x, CGFloat p0_y, CGFloat p1_x, CGFloat p1_y,
                           CGFloat p2_x, CGFloat p2_y, CGFloat p3_x, CGFloat p3_y,
                           CGFloat *i_x, CGFloat *i_y)
{
    CGFloat s1_x, s1_y, s2_x, s2_y;
    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;
    
    CGFloat s, t;
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
    
    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
        if (i_x != NULL)
            *i_x = (CGFloat) p0_x + (t * s1_x);
        if (i_y != NULL)
            *i_y = (CGFloat) p0_y + (t * s1_y);
        return YES;
    }
    
    return NO; // No collision
}


#pragma mark -


- (NSInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == _loseAlertView) {
        [_spiritTimer invalidate];
        [_timer invalidate];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate loadLevelNum:_level.index];
    }
    
    if (alertView == _winAlertView) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate loadLevelNum:_level.index + 1];
    }
}

- (void)win {
    [_timer invalidate];
    [_spiritTimer invalidate];
    
    _winAlertView = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"You've escaped the grasping claws of the traitor houndmen, for now...." delegate:self cancelButtonTitle:@"Next Level" otherButtonTitles:nil, nil];
    [_winAlertView show];
}

@end
