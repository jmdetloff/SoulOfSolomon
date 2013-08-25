//
//  WallView.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"
#import "WallView.h"
#import "KeyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WallView {
    NSMutableArray *_doorViews;
}

@synthesize doorViews = _doorViews;


- (id)initWithFrame:(CGRect)frame wall:(Wall *)wall {
    self = [super initWithFrame:frame];
    if (self) {
        _wall = wall;
        _doorViews = [[NSMutableArray alloc] init];
        
        self.clipsToBounds = NO;
        
        if (wall.vertical) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vert_wall_full"]];

            if (frame.origin.y + frame.size.height != 748) {
                UIImageView *frontCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vert_wall_endfront"]];
                frontCap.frame = CGRectMake(0, frame.size.height - frontCap.frame.size.height, frontCap.frame.size.width, frontCap.frame.size.height);
                [self addSubview:frontCap];
            }

            UIImageView *backCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vert_wall_endback"]];
            [self addSubview:backCap];
        } else {
            UIImageView *rightCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horz_wall_endright"]];
            rightCap.frame = CGRectMake(frame.size.width - rightCap.frame.size.width, 0, rightCap.frame.size.width, rightCap.frame.size.height);
            [self addSubview:rightCap];
            
            UIImageView *leftCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horz_wall_endleft"]];
            [self addSubview:leftCap];
        }
        
        for (Door *door in wall.doors) {
            UIImageView *doorView = [[UIImageView alloc] init];
            
            CGPoint doorLocation;
            if (wall.vertical) {
                doorLocation = CGPointMake(frame.size.width/2, frame.size.height*door.location/100.f);
            } else {
                doorLocation = CGPointMake(frame.size.width*door.location/100.f, frame.size.height/2);
            }
            
            doorView.image = [self getDoorImage:door wall:wall];
            doorView.frame = CGRectMake(doorView.frame.origin.x, doorView.frame.origin.y, doorView.image.size.width, doorView.image.size.height);
            doorView.center = doorLocation;
            [self addSubview:doorView];
            
            [_doorViews addObject:doorView];
        }
        
        if (!wall.vertical) {
            int numBackgroundSections = [_doorViews count] + 1;
            for (int i = 0; i < numBackgroundSections; i++) {
                UIView *backgroundSection = [[UIView alloc] init];
                backgroundSection.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horz_wall_full"]];
                [self insertSubview:backgroundSection atIndex:0];
                
                UIView *nextDoorView = (i == numBackgroundSections - 1 ? nil : _doorViews[i]);
                UIView *lastDoorView = (i == 0 ? nil : _doorViews[i-1]);
                
                CGFloat sectionStart = (i == 0 ? 0 : lastDoorView.frame.origin.x + lastDoorView.frame.size.width);
                CGFloat sectionEnd = (i ==  numBackgroundSections - 1 ? frame.size.width : nextDoorView.frame.origin.x);
                
                backgroundSection.frame = CGRectMake(sectionStart, 0, sectionEnd - sectionStart, frame.size.height);
            }
        }
    }
    return self;
}


- (UIImage *)getDoorImage:(Door *)door wall:(Wall *)wall {
    if (wall.vertical) {
        KeyView *keyView = door.key.display;
        if (keyView == nil) {
            return [UIImage imageNamed:@"vert_door_open"];
        } else if (keyView.color == Aqua) {
            return [UIImage imageNamed:@"vert_door_aqua"];
        } else {
            return [UIImage imageNamed:@"vert_door_fuchsia"];
        }
    } else {
        KeyView *keyView = door.key.display;
        if (keyView == nil) {
            return [UIImage imageNamed:@"horz_door_open"];
        } else if (keyView.color == Aqua) {
            return [UIImage imageNamed:@"horz_door_aqua"];
        } else {
            return [UIImage imageNamed:@"horz_door_fuchsia"];
        }
    }
}


- (void)gotKey:(KeyView *)key {

    [_wall.doors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Door *door = (Door *)obj;
        UIImageView *doorView = _doorViews[idx];
        
        KeyView *neededView = door.key.display;
        if (neededView != nil && key == neededView) {
            doorView.image = (_wall.vertical ? [UIImage imageNamed:@"vert_door_open"] : [UIImage imageNamed:@"horz_door_open"]);
        }
    }];
    
}





@end
