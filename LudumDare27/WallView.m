//
//  WallView.m
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "Level.h"
#import "WallView.h"
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
        self.backgroundColor = [UIColor brownColor];
        
        for (Door *door in wall.doors) {
            UIImageView *doorView = [[UIImageView alloc] init];
            
            CGPoint doorLocation;
            if (frame.size.height > frame.size.width) {
                doorLocation = CGPointMake(0, frame.size.height*door.location/100.f);
            } else {
                doorLocation = CGPointMake(frame.size.width*door.location/100.f, 0);
            }
            
            doorView.image = [self doorImageOpen:NO];
            doorView.frame = CGRectMake(doorView.frame.origin.x, doorView.frame.origin.y, doorView.image.size.width, doorView.image.size.height);
            doorView.center = doorLocation;
            [self addSubview:doorView];
            
            [_doorViews addObject:doorView];
        }
    }
    return self;
}


- (void)openDoor:(UIView *)door {
    UIImageView *doorView = (UIImageView *)door;
    doorView.image = [self doorImageOpen:YES];
    
    double delayInSeconds = 0.75;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        doorView.image = [self doorImageOpen:NO];
    });
}


- (UIImage *)doorImageOpen:(BOOL)open {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)];
    
    UIImage *glyphImage;
    
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, (open ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor));
    
    path.lineWidth = 1;
    [path fill];
    
    glyphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return glyphImage;
}


@end
