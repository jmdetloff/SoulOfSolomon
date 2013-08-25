//
//  Level.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"

@implementation Level



@end




@implementation Wall
@end


@implementation Door
- (id)initWithLocation:(int)location {
    self = [super init];
    if (self) {
        _location = location;
    }
    return self;
}
@end


@implementation Key
@end


@implementation Guard
@end


@implementation NoiseMaker
@end

@implementation Light
@end

@implementation Staller
@end