//
//  LevelGenerator.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"
#import "LevelGenerator.h"
#import "KeyView.h"
#import "BellView.h"

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



+ (Level *)getLevelTwo {
    Level *level = [[Level alloc] init];
    level.index = 2;
    
    level.kingStartPosition = CGPointMake(.125*1024, .25*748);
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    Key *key1 = [[Key alloc] init];
    key1.location = CGPointMake(0.1*1024, 0.9*748);
    key1.display = [[KeyView alloc] initWithFrame:CGRectMake(0, 0, 40, 40) color:Aqua];
    [keys addObject:key1];
    
    level.keys = keys;
    
    NSMutableArray *walls = [[NSMutableArray alloc] init];
    
    Wall *wall1 = [[Wall alloc] init];
    wall1.startPoint = CGPointMake(.25*1024, 0);
    wall1.endPoint = CGPointMake(.25*1024, 748);
    wall1.doors = [@[[[Door alloc] initWithLocation:25], [[Door alloc] initWithLocation:65]] mutableCopy];
    wall1.vertical = YES;
    [walls addObject:wall1];
    
    Wall *wall2 = [[Wall alloc] init];
    wall2.startPoint = CGPointMake(.50*1024, 0);
    wall2.endPoint = CGPointMake(.50*1024, 748);
    
    Door *lockedDoor = [[Door alloc] initWithLocation:50];
    lockedDoor.key = key1;
    
    wall2.doors = [@[lockedDoor] mutableCopy];
    wall2.vertical = YES;
    [walls addObject:wall2];
    
    Wall *wall3 = [[Wall alloc] init];
    wall3.startPoint = CGPointMake(.75*1024, 0);
    wall3.endPoint = CGPointMake(.75*1024, 748);
    wall3.doors = [@[[[Door alloc] initWithLocation:17], [[Door alloc] initWithLocation:50]] mutableCopy];
    wall3.vertical = YES;
    [walls addObject:wall3];
    
    Wall *wall4 = [[Wall alloc] init];
    wall4.startPoint = CGPointMake(0, .50*748);
    wall4.endPoint = CGPointMake(.25*1024, .50*748);
    wall4.doors = [@[[[Door alloc] initWithLocation:50]] mutableCopy];
    [walls addObject:wall4];

    Wall *wall5 = [[Wall alloc] init];
    wall5.startPoint = CGPointMake(.50*1024, .38*748);
    wall5.endPoint = CGPointMake(.75*1024, .38*748);
    
    Door *door = [[Door alloc] initWithLocation:50];
    door.isSticky = YES;
    wall5.doors = [@[door] mutableCopy];

    [walls addObject:wall5];
    
    Wall *wall6 = [[Wall alloc] init];
    wall6.startPoint = CGPointMake(.92*1024, .40*748);
    wall6.endPoint = CGPointMake(1024, .40*748);
    [walls addObject:wall6];
    
    level.walls = walls;
    
    NSMutableArray *guards = [[NSMutableArray alloc] init];
    
    Guard *guard1 = [[Guard alloc] init];
    guard1.startPoint = CGPointMake(.1*1024, .75*748);
    guard1.endPoint = CGPointMake(.1*1024, .75*748);
    guard1.initialAngle = M_PI * 1.7;
    [guards addObject:guard1];

    Guard *guard2 = [[Guard alloc] init];
    guard2.startPoint = CGPointMake(.375*1024, .45*748);
    guard2.endPoint = CGPointMake(.375*1024, .85*748);
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
    guard5.startPoint = CGPointMake(.9*1024, .50*748);
    guard5.endPoint = CGPointMake(.9*1024, .50*748);
    guard5.initialAngle = M_PI;
    [guards addObject:guard5];
    
    level.guards = guards;
    
    NSMutableArray *noiseMakers = [[NSMutableArray alloc] init];
    
    NoiseMaker *maker1 = [[NoiseMaker alloc] init];
    maker1.location = CGPointMake(50, 50);
    maker1.display = [LevelGenerator genericMakerView];
    maker1.activateTime = 0;
    [noiseMakers addObject:maker1];
    
    NoiseMaker *maker2 = [[NoiseMaker alloc] init];
    maker2.location = CGPointMake(50, 700);
    maker2.display = [LevelGenerator genericMakerView];
    maker2.activateTime = 0;
    [noiseMakers addObject:maker2];
    
    NoiseMaker *maker3 = [[NoiseMaker alloc] init];
    maker3.location = CGPointMake(0.875*1024, 700);
    maker3.display = [LevelGenerator genericMakerView];
    maker3.activateTime = 0;
    [noiseMakers addObject:maker3];
    
    level.noiseMakers = noiseMakers;
    
    NSMutableArray *lights = [[NSMutableArray alloc] init];
    
    Light *light1 = [[Light alloc] init];
    light1.location = CGPointMake(0.375*1024, 30);
    light1.zone = CGRectMake(0.25*1024, 0, 0.25*1024, 748);
    [lights addObject:light1];
    
    Light *light2 = [[Light alloc] init];
    light2.location = CGPointMake(924, 130);
    light2.zone = CGRectMake(0.75*1024, 0, 0.25*1024, 748);
    [lights addObject:light2];
    
    level.lights = lights;
    
    level.numCoins = 3;
    
    level.winZone = CGRectMake(.75*1024, .9*748, .25*1024, .1*748);
    
    return level;
}


+ (Level *)getLevelOne {
    Level *level = [[Level alloc] init];
    level.index = 1;
    
    level.kingStartPosition = CGPointMake(35, .75*748);

    
    NSMutableArray *walls = [[NSMutableArray alloc] init];
    
    Wall *wall1 = [[Wall alloc] init];
    wall1.startPoint = CGPointMake(.33*1024, 0);
    wall1.endPoint = CGPointMake(.33*1024, 748);
    wall1.doors = [@[[[Door alloc] initWithLocation:75]] mutableCopy];
    wall1.vertical = YES;
    [walls addObject:wall1];
    
    Wall *wall2 = [[Wall alloc] init];
    wall2.startPoint = CGPointMake(.66*1024, 0);
    wall2.endPoint = CGPointMake(.66*1024, 748);
    wall2.doors = [@[[[Door alloc] initWithLocation:10]] mutableCopy];
    wall2.vertical = YES;
    [walls addObject:wall2];
    
    Wall *wall3 = [[Wall alloc] init];
    wall3.startPoint = CGPointMake(0, 0.5*748);
    wall3.endPoint = CGPointMake(.33*1024, 0.5*748);
    wall3.doors = [@[[[Door alloc] initWithLocation:50]] mutableCopy];
    wall3.vertical = NO;
    [walls addObject:wall3];
    
    level.walls = walls;
    
    NSMutableArray *guards = [[NSMutableArray alloc] init];
    
    Guard *guard1 = [[Guard alloc] init];
    guard1.startPoint = CGPointMake(.29*1024, .75*748);
    guard1.endPoint = CGPointMake(.29*1024, .75*748);
    guard1.initialAngle = M_PI;
    [guards addObject:guard1];
    
    Guard *guard2 = [[Guard alloc] init];
    guard2.startPoint = CGPointMake(.57*1024, .56*748);
    guard2.endPoint = CGPointMake(.43*1024, .67*748);
    [guards addObject:guard2];
    
    Guard *guard3 = [[Guard alloc] init];
    guard3.startPoint = CGPointMake(.45*1024, .4*748);
    guard3.endPoint = CGPointMake(.45*1024, .4*748);
    guard3.initialAngle = M_PI/2;
    [guards addObject:guard3];

    Guard *guard5 = [[Guard alloc] init];
    guard5.startPoint = CGPointMake(.85*1024, .8*748);
    guard5.endPoint = CGPointMake(.85*1024, .8*748);
    guard5.initialAngle = M_PI/2;
    [guards addObject:guard5];
    
    level.guards = guards;
    
    NSMutableArray *noiseMakers = [[NSMutableArray alloc] init];

    NoiseMaker *maker1 = [[NoiseMaker alloc] init];
    maker1.location = CGPointMake(.125 * 1024, .125 *748);
    maker1.display = [LevelGenerator genericMakerView];
    maker1.activateTime = 0;
    [noiseMakers addObject:maker1];

    level.noiseMakers = noiseMakers;
    
    NSMutableArray *lights = [[NSMutableArray alloc] init];

    Light *light1 = [[Light alloc] init];
    light1.location = CGPointMake(0.85*1024, 110);
    light1.zone = CGRectMake(0.66*1024, 0, 0.33*1024 + 20, 748);
    [lights addObject:light1];

    level.lights = lights;
    
    level.numCoins = 3;
    
    level.winZone = CGRectMake(.75*1024, .9*748, .25*1024, .1*748);
    
    return level;

}


+ (Level *)getLevelThree {
    return nil;
}


+ (BellView *)genericMakerView {
    BellView *makerView = [[BellView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    return makerView;
}


@end
