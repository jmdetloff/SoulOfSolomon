//
//  LevelGenerator.h
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelGenerator : NSObject
+ (Level *)getLevel:(int)levelNum;
@end
