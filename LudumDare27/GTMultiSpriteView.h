//
//  GTMultiSpriteView.h
//  Grace
//
//  Created by John Detloff on 1/22/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTMultiSpriteView : UIImageView

- (void)setAnimation:(NSArray *)animation duration:(NSTimeInterval)duration forKey:(NSString *)key;
- (void)setTransitionAnimation:(NSArray *)transitionAnimation duration:(NSTimeInterval)duration fromKey:(NSString *)fromKey toKey:(NSString *)toKey;
- (void)setAnimationToAnimationWithKey:(NSString *)animationKey;

@end
