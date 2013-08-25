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
            
            wallFrame = CGRectMake(xStart, wall.startPoint.y - 48, width, 96);
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
    for (WallView *view in _wallViews) {
        [self.view addSubview:view];
    }
    
    _keyViews = [NSMutableArray array];
    
    [_level.keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Key *key = (Key *)obj;
        
        UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        keyView.backgroundColor = [UIColor purpleColor];
        keyView.tag = idx;
        keyView.center = key.location;
        [self.view addSubview:keyView];
        
        [_keyViews addObject:keyView];
    }];
 
    _gottenKeys = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stone_floor"]];
}


#pragma mark -


- (void)move {
    [_kingBody move:0.02];
    for (GuardView *gv in _guardViews) {
        [gv move:0.02];
        if (![self wallIntersectionBetweenPointA:_kingBody.center pointB:gv.center]) {
            [gv tryToSpot:_kingBody.center];
        }
    }
    for (UIView *keyView in _keyViews) {
        double distance = sqrt(pow((keyView.center.x - _kingBody.center.x), 2.0) + pow((keyView.center.y - _kingBody.center.y), 2.0));
        if (distance < 30) {
            [keyView removeFromSuperview];
            [_gottenKeys addObject:[_level.keys objectAtIndex:keyView.tag]];
        }
    }
}



#pragma mark -


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    if (!CGPointEqualToPoint(_kingBody.center, loc)) {
        [_kingBody attemptToSetDestination:loc maxDepth:INFINITY];
        if (!CGPointEqualToPoint(_kingBody.center, _kingBody.currentDestination)) {
            _kingBody.moving = YES;
        }
        _kingBody.facingLeft = _kingBody.currentDestination.x < _kingBody.center.x;
        _kingBody.facingUp = _kingBody.currentDestination.y < _kingBody.center.y;
    }
    
//    for (GuardView *guardView in _guardViews) {
//        [guardView beLuredToLocation:loc];
////        if (![self wallIntersectionBetweenPointA:loc pointB:guardView.center]) {
////            [guardView tryToSpot:loc];
////        }
//    }
}



#pragma mark - pathfinding



- (void)navigatingView:(DoorNavigatingView *)view reachedIntermediaryDestination:(CGPoint)dest nextDest:(CGPoint)nextDest {
    for (WallView *wallView in _wallViews) {
        Wall *wall = wallView.wall;
        [wallView.doorViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *doorView = (UIView *)obj;
            Door *door = wall.doors[idx];
            
            CGPoint doorLocation = (wall.vertical ? CGPointMake(wall.startPoint.x, wall.startPoint.y + (wall.endPoint.y - wall.startPoint.y)*door.location/100)
                                    : CGPointMake(wall.startPoint.x + (wall.endPoint.x - wall.startPoint.x)*door.location/100, wall.startPoint.y));
            if (CGPointEqualToPoint(doorLocation, dest)) {
                [wallView openDoor:doorView];
                *stop = YES;
            }
        }];
    }
    
    if (view == _kingBody) {
            _kingBody.moving = YES;
            _kingBody.facingLeft = nextDest.x < _kingBody.center.x;
            _kingBody.facingUp = nextDest.y < _kingBody.center.y;
    }
}


- (void)navigatingView:(DoorNavigatingView *)view reachedFinalDestination:(CGPoint)dest {
    if (view == _kingBody) {
        _kingBody.moving = NO;
    }
}


- (BOOL)canReachDest:(CGPoint)dest fromLocation:(CGPoint)loc maxDepth:(int)maxDepth nextLoc:(CGPoint *)nextLoc {
    NSMutableArray *nodePath = [_finder searchPathFromPoint:loc toPoint:dest nodes:_doorNodes maxDepth:maxDepth];
    if ([nodePath count] == 0) {
        return NO;
    }
    
    *nextLoc = ((DoorNode *)[nodePath objectAtIndex:0]).location;
    return YES;
}


- (BOOL)nodeA:(DoorNode *)nodeA isAdjacentToNodeB:(DoorNode *)nodeB {
    if ((nodeA.door.key != nil && ![_gottenKeys containsObject:nodeA.door.key]) || (nodeB.door.key != nil && ![_gottenKeys containsObject:nodeB.door.key])) {
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

@end
