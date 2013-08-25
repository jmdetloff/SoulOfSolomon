//
//  KeyView.m
//  LudumDare27
//
//  Created by John Detloff on 8/25/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "KeyView.h"

@implementation KeyView

static NSString * const kAquaKey = @"kAquaKey";
static NSString * const kFuchsiaKey = @"kFuchsiaKey";

- (id)initWithFrame:(CGRect)frame color:(KeyColor)color {
    self = [super initWithFrame:frame];
    if (self) {
        
        _color = color;
        
        NSArray *glitterAqua = @[[UIImage imageNamed:@"key_aqua0000.png"],
                             [UIImage imageNamed:@"key_aqua0001.png"],
                             [UIImage imageNamed:@"key_aqua0002.png"],
                             [UIImage imageNamed:@"key_aqua0003.png"],
                             [UIImage imageNamed:@"key_aqua0004.png"],
                             [UIImage imageNamed:@"key_aqua0005.png"],
                             [UIImage imageNamed:@"key_aqua0006.png"],
                             [UIImage imageNamed:@"key_aqua0007.png"],
                              [UIImage imageNamed:@"key_aqua0008.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"],
                                 [UIImage imageNamed:@"key_aqua0000.png"]];
        
        NSArray *glitterFuchsia = @[[UIImage imageNamed:@"key_fuchsia0000.png"],
                                 [UIImage imageNamed:@"key_fuchsia0001.png"],
                                 [UIImage imageNamed:@"key_fuchsia0002.png"],
                                 [UIImage imageNamed:@"key_fuchsia0003.png"],
                                 [UIImage imageNamed:@"key_fuchsia0004.png"],
                                 [UIImage imageNamed:@"key_fuchsia0005.png"],
                                 [UIImage imageNamed:@"key_fuchsia0006.png"],
                                 [UIImage imageNamed:@"key_fuchsia0007.png"],
                                 [UIImage imageNamed:@"key_fuchsia0008.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"],
                                    [UIImage imageNamed:@"key_fuchsia0000.png"]];
        
        [self setAnimation:glitterAqua duration:3 forKey:kAquaKey];
        [self setAnimation:glitterFuchsia duration:3 forKey:kFuchsiaKey];
        
        switch (color) {
            case Aqua:
                [self setAnimationToAnimationWithKey:kAquaKey];
                break;
                
            case Fuchsia:
                [self setAnimationToAnimationWithKey:kFuchsiaKey];
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end
