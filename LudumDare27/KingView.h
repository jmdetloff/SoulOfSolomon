//
//  KingView.h
//  LudumDare27
//
//  Created by John Detloff on 8/24/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "DoorNavigatingView.h"


@interface KingView : DoorNavigatingView

@property (nonatomic, assign) BOOL facingUp;
@property (nonatomic, assign) BOOL facingLeft;
@property (nonatomic, assign) BOOL moving;

@end
