//
//  KeyView.h
//  LudumDare27
//
//  Created by John Detloff on 8/25/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "GTMultiSpriteView.h"

typedef enum {
    Aqua,
    Fuchsia
} KeyColor;

@interface KeyView : GTMultiSpriteView

@property (nonatomic, assign, readonly) KeyColor color;

- (id)initWithFrame:(CGRect)frame color:(KeyColor)color;
@end
