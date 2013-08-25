//
//  Level.h
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong) NSMutableArray *walls;
@property (nonatomic, strong) NSMutableArray *guards;
@property (nonatomic, strong) NSMutableArray *lures;
@property (nonatomic, strong) NSMutableArray *lights;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, assign) CGPoint kingStartPosition;

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


@interface Key : NSObject
@property (nonatomic, assign) CGPoint location;
@end