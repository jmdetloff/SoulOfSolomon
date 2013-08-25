//
//  PathFinder.m
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "PathFinder.h"

@implementation PathFinder


- (NSMutableArray *)searchPathFromPoint:(CGPoint)initialPoint toPoint:(CGPoint)endPoint nodes:(NSArray *)doorNodes maxDepth:(int)depth {

    NSMutableArray *queue = [doorNodes mutableCopy];
    
    // reset our nodes from the last search
    for (DoorNode *node in doorNodes) {
        node.visited = NO;
        node.distance = INFINITY;
        node.closestParent = nil;
    }
    
    DoorNode *initialNode = [[DoorNode alloc] init];
    initialNode.location = initialPoint;
    initialNode.distance = 0;
    initialNode.visited = YES;
    
    DoorNode *finalNode = [[DoorNode alloc] init];
    finalNode.distance = INFINITY;
    finalNode.location = endPoint;

    [queue addObject:finalNode];
    
    BOOL found = [self searchFromNode:initialNode unvisited:queue finalNode:finalNode];
    
    if (finalNode.distance > depth || !found) {
        return nil;
    }
    
    NSMutableArray *path = [NSMutableArray array];
    DoorNode *lastNode = finalNode;
    while (lastNode != nil) {
        [path insertObject:lastNode atIndex:0];
        lastNode = lastNode.closestParent;
    }
    
    // remove the intial node, we don't need that anymore
    [path removeObjectAtIndex:0];
    
    return path;
}


- (BOOL)searchFromNode:(DoorNode *)currentNode unvisited:(NSMutableArray *)unvisited finalNode:(DoorNode *)finalNode {
    if (currentNode == finalNode) {
        return YES;
    }
    
    NSArray *adjacents = [self adjacentNodes:currentNode fromNodes:unvisited];
    
    for (DoorNode *node in adjacents) {
        double distance = sqrt(pow((node.location.x - currentNode.location.x), 2.0) + pow((node.location.y - currentNode.location.y), 2.0));
        distance += currentNode.distance;
        
        if (node.distance > distance) {
            node.distance = distance;
            node.closestParent = currentNode;
        }
    }
    
    DoorNode *nextNodeToVisit = nil;
    for (DoorNode *node in unvisited) {
        if (nextNodeToVisit == nil || nextNodeToVisit.distance > node.distance) {
            nextNodeToVisit = node;
        }
    }
    [unvisited removeObject:nextNodeToVisit];
    
    return [self searchFromNode:nextNodeToVisit unvisited:unvisited finalNode:finalNode];
}


- (NSMutableArray *)adjacentNodes:(DoorNode *)nodeA fromNodes:(NSArray *)otherNodes {
    NSMutableArray *adjacents = [NSMutableArray array];
    
    for (DoorNode *node in otherNodes) {
        if ([_delegate nodeA:nodeA isAdjacentToNodeB:node]) {
            [adjacents addObject:node];
        }
    }
    
    return adjacents;
}


@end

@implementation DoorNode
@end
