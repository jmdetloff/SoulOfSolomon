//
//  Level.h
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "GTMultiSpriteView.h"
#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSMutableArray *walls;
@property (nonatomic, strong) NSMutableArray *guards;
@property (nonatomic, strong) NSMutableArray *lights;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableArray *noiseMakers;
//@property (nonatomic, strong) NSMutableArray *stallers;
@property (nonatomic, assign) CGPoint kingStartPosition;
@property (nonatomic, assign) int numCoins;
@property (nonatomic, assign) CGRect winZone;

@end

@class BellView;

@interface NoiseMaker : NSObject
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) BellView *display;
@property (nonatomic, assign) NSTimeInterval activateTime;
@end


@interface Wall : NSObject
@property (nonatomic, strong) NSMutableArray *doors;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) BOOL vertical;
@end


@class Key;

@interface Door : NSObject
@property (nonatomic, assign) BOOL isSticky;
@property (nonatomic, assign) int location;
@property (nonatomic, strong) Key *key;
- (id)initWithLocation:(int)location;
@end


@interface Guard : NSObject
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGFloat initialAngle;
@end


@class KeyView;

@interface Key : NSObject
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, strong) KeyView *display;
@end


@interface Light : NSObject
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGRect zone;
@end

@interface Staller : NSObject
@property (nonatomic, assign) CGPoint location;
@end