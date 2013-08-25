//
//  GuardView.h
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "DoorNavigatingView.h"
#import <UIKit/UIKit.h>

@class Guard;
@class GuardView;


@interface GuardView : DoorNavigatingView

- (id)initWithGuard:(Guard *)guard delegate:(id<GuardMoveDelegate>)delegate;
- (void)beLuredToLocation:(CGPoint)location distance:(int)distance;
- (BOOL)tryToSpot:(CGPoint)location;

@end
