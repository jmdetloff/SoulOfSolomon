//
//  GTMultiSpriteView.m
//  Grace
//
//  Created by John Detloff on 1/22/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "GTMultiSpriteView.h"

@interface GTMultiSpriteAnimation : NSObject
@property (nonatomic, strong) NSArray *animationImages;
@property (nonatomic, assign) NSTimeInterval duration;
@end
@implementation GTMultiSpriteAnimation
@end

@interface GTAnimationTrigger : NSObject
@property (nonatomic, strong) NSString *fromKey;
@property (nonatomic, strong) NSString *toKey;
@property (nonatomic, strong) GTMultiSpriteAnimation *animation;
@end
@implementation GTAnimationTrigger
@end


@implementation GTMultiSpriteView {
    NSString *_currentAnimationKey;
    NSMutableDictionary *_animations;
    NSMutableArray *_transitionTriggers;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animations = [[NSMutableDictionary alloc] init];
        _transitionTriggers = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)setAnimation:(NSArray *)animationImages duration:(NSTimeInterval)duration forKey:(NSString *)key {
    GTMultiSpriteAnimation *animation = [[GTMultiSpriteAnimation alloc] init];
    animation.animationImages = animationImages;
    animation.duration = duration;
    [_animations setObject:animation forKey:key];
}


- (void)setTransitionAnimation:(NSArray *)transitionAnimation duration:(NSTimeInterval)duration fromKey:(NSString *)fromKey toKey:(NSString *)toKey {
    GTAnimationTrigger *replacedTrigger = nil;
    for (GTAnimationTrigger *trigger in _transitionTriggers) {
        if ([trigger.fromKey isEqualToString:fromKey] && [trigger.toKey isEqualToString:toKey]) {
            replacedTrigger = trigger;
            break;
        }
    }
    if (replacedTrigger) [_transitionTriggers removeObject:replacedTrigger];
    
    GTMultiSpriteAnimation *animation = [[GTMultiSpriteAnimation alloc] init];
    animation.animationImages = transitionAnimation;
    animation.duration = duration;
    GTAnimationTrigger *animationTrigger = [[GTAnimationTrigger alloc] init];
    animationTrigger.animation = animation;
    animationTrigger.fromKey = fromKey;
    animationTrigger.toKey = toKey;
    [_transitionTriggers addObject:animationTrigger];
}


- (void)setAnimationToAnimationWithKey:(NSString *)animationKey {
    if ([animationKey isEqualToString:_currentAnimationKey]) {
        return;
    }
    
    GTMultiSpriteAnimation *animation = [_animations objectForKey:animationKey];
    GTAnimationTrigger *triggeredAnimation = nil;
    for (GTAnimationTrigger *trigger in _transitionTriggers) {
        if ((trigger.fromKey == nil || [trigger.fromKey isEqualToString:_currentAnimationKey]) && (trigger.toKey == nil || [trigger.toKey isEqualToString:animationKey])) {
            triggeredAnimation = trigger;
        }
    }
    
    if (triggeredAnimation == nil) {
        [self animateWithImages:animation.animationImages duration:animation.duration repeatCount:0];
    } else {
        self.image = [animation.animationImages objectAtIndex:0];
        GTMultiSpriteAnimation *transitionAnimation = triggeredAnimation.animation;
        [self animateWithImages:transitionAnimation.animationImages duration:transitionAnimation.duration repeatCount:1];
        
        NSTimeInterval delayInSeconds = transitionAnimation.duration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([animationKey isEqualToString:_currentAnimationKey]) {
                [self animateWithImages:animation.animationImages duration:animation.duration repeatCount:0];
            }
        });
    }
    
    _currentAnimationKey = animationKey;
}


- (void)animateWithImages:(NSArray *)animationImages duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount {
    if ([animationImages count] == 1) {
        [self stopAnimating];
        self.image = [animationImages objectAtIndex:0];
    } else {
        self.animationImages = animationImages;
        self.animationRepeatCount = repeatCount;
        self.animationDuration = duration;
        [self startAnimating];
    }
}


@end
