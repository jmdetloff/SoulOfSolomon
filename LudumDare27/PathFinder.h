//
//  PathFinder.h
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wall;
@class DoorNode;

@protocol PathFinderDelegate <NSObject>
- (BOOL)nodeA:(DoorNode *)nodeA isAdjacentToNodeB:(DoorNode *)nodeB;
@end


@interface PathFinder : NSObject

@property (nonatomic, weak) id<PathFinderDelegate> delegate;

- (NSMutableArray *)searchPathFromPoint:(CGPoint)initialPoint toPoint:(CGPoint)endPoint nodes:(NSArray *)doorNodes maxDepth:(int)depth;

@end

@class Door;

@interface DoorNode : NSObject
@property (nonatomic, strong) Door *door;
@property (nonatomic, strong) Wall *wall;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, strong) DoorNode *closestParent;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) BOOL visited;
@end
