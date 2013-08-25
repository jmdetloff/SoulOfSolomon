//
//  WallView.h
//  LudumDare27
//
//  Created by John Detloff on 8/23/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wall;
@interface WallView : UIView

@property (nonatomic, strong, readonly) Wall *wall;
@property (nonatomic, strong, readonly) NSArray *doorViews;

- (id)initWithFrame:(CGRect)frame wall:(Wall *)wall;
- (void)openDoor:(UIView *)door;

@end
