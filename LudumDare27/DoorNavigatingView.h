//
//  DoorNavigatingView.h
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMultiSpriteView.h"

@class DoorNavigatingView;

@protocol GuardMoveDelegate <NSObject>
- (BOOL)navigatingView:(DoorNavigatingView *)view canReachDest:(CGPoint)dest fromLocation:(CGPoint)loc maxDepth:(int)maxDepth nextLoc:(CGPoint *)nextLoc;
- (void)navigatingView:(DoorNavigatingView *)view reachedIntermediaryDestination:(CGPoint)dest nextDest:(CGPoint)nextDest;
- (void)navigatingView:(DoorNavigatingView *)view reachedFinalDestination:(CGPoint)dest;
@end


@interface DoorNavigatingView : GTMultiSpriteView

@property (nonatomic, weak) id<GuardMoveDelegate> delegate;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) CGPoint currentDestination;
@property (nonatomic, assign) CGPoint finalDestination;
@property (nonatomic, assign) CGFloat currentAngle;

- (id)initWithDelegate:(id<GuardMoveDelegate>)delegate;
- (void)move:(NSTimeInterval)moveTime;
- (BOOL)reachedDestination;
- (BOOL)attemptToSetDestination:(CGPoint)attemptedDestination maxDepth:(int)maxDepth;

@end
