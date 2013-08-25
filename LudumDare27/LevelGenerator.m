//
//  LevelGenerator.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"
#import "LevelGenerator.h"

@implementation LevelGenerator

+ (Level *)getLevel:(int)levelNum {    
    switch (levelNum) {
        case 1:
            return [self getLevelOne];
            break;
            
        case 2:
            return [self getLevelTwo];
            break;
            
        case 3:
            return [self getLevelThree];
            break;
            
        default:
            break;
    }
    
    return nil;
}



+ (Level *)getLevelOne {
    Level *level = [[Level alloc] init];
    
    level.kingStartPosition = CGPointMake(.125*1024, .25*748);
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    Key *key1 = [[Key alloc] init];
    key1.location = CGPointMake(0.1*1024, 0.9*748);
    [keys addObject:key1];
    
    level.keys = keys;
    
    NSMutableArray *walls = [[NSMutableArray alloc] init];
    
    Wall *wall1 = [[Wall alloc] init];
    wall1.startPoint = CGPointMake(.25*1024, 0);
    wall1.endPoint = CGPointMake(.25*1024, 748);
    wall1.doors = [@[[[Door alloc] initWithLocation:25], [[Door alloc] initWithLocation:75]] mutableCopy];
    wall1.vertical = YES;
    [walls addObject:wall1];
    
    Wall *wall2 = [[Wall alloc] init];
    wall2.startPoint = CGPointMake(.50*1024, 0);
    wall2.endPoint = CGPointMake(.50*1024, 748);
    
    Door *lockedDoor = [[Door alloc] initWithLocation:75];
    lockedDoor.key = key1;
    
    wall2.doors = [@[lockedDoor] mutableCopy];
    wall2.vertical = YES;
    [walls addObject:wall2];
    
    Wall *wall3 = [[Wall alloc] init];
    wall3.startPoint = CGPointMake(.75*1024, 0);
    wall3.endPoint = CGPointMake(.75*1024, 748);
    wall3.doors = [@[[[Door alloc] initWithLocation:12], [[Door alloc] initWithLocation:75]] mutableCopy];
    wall3.vertical = YES;
    [walls addObject:wall3];
    
    Wall *wall4 = [[Wall alloc] init];
    wall4.startPoint = CGPointMake(0, .50*748);
    wall4.endPoint = CGPointMake(.25*1024, .50*748);
    wall4.doors = [@[[[Door alloc] initWithLocation:50]] mutableCopy];
    [walls addObject:wall4];

    Wall *wall5 = [[Wall alloc] init];
    wall5.startPoint = CGPointMake(.50*1024, .25*748);
    wall5.endPoint = CGPointMake(.75*1024, .25*748);
    
    Door *door = [[Door alloc] initWithLocation:50];
    door.isSticky = YES;
    wall5.doors = [@[door] mutableCopy];

    [walls addObject:wall5];
    
    Wall *wall6 = [[Wall alloc] init];
    wall6.startPoint = CGPointMake(.92*1024, .75*748);
    wall6.endPoint = CGPointMake(1024, .75*748);
    [walls addObject:wall6];
    
    level.walls = walls;
    
    NSMutableArray *guards = [[NSMutableArray alloc] init];
    
    Guard *guard1 = [[Guard alloc] init];
    guard1.startPoint = CGPointMake(.125*1024, .7*748);
    guard1.endPoint = CGPointMake(.125*1024, .7*748);
    guard1.initialAngle = M_PI * 1.5;
    [guards addObject:guard1];

    Guard *guard2 = [[Guard alloc] init];
    guard2.startPoint = CGPointMake(.375*1024, .25*748);
    guard2.endPoint = CGPointMake(.375*1024, .75*748);
    [guards addObject:guard2];

    Guard *guard3 = [[Guard alloc] init];
    guard3.startPoint = CGPointMake(.625*1024, .125*748);
    guard3.endPoint = CGPointMake(.625*1024, .875*748);
    [guards addObject:guard3];
    
    Guard *guard4 = [[Guard alloc] init];
    guard4.startPoint = CGPointMake(.625*1024, .875*748);
    guard4.endPoint = CGPointMake(.625*1024, .125*748);
    [guards addObject:guard4];
    
    Guard *guard5 = [[Guard alloc] init];
    guard5.startPoint = CGPointMake(.9*1024, .75*748);
    guard5.endPoint = CGPointMake(.9*1024, .75*748);
    guard5.initialAngle = M_PI;
    [guards addObject:guard5];
    
    level.guards = guards;
    return level;
}

+ (Level *)getLevelTwo {
    return nil;
}

+ (Level *)getLevelThree {
    return nil;
}

@end
