//
//  CALayer+KeyframeAnimations.m
//  Datalove
//
//  Created by Christoph on 3/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "CALayer+KeyframeAnimations.h"

@implementation CAKeyframeBlocksAnimation

- (id)init
{
    self = [super init];
    if (self) {
        self.completion = nil;
        self.start = nil;
        self.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.completion = nil;
}

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.start) {
        self.start();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion != nil) {
        self.completion(flag);
    }
}

@end

@implementation CALayer (KeyframeAnimations)

-(void)addAnimationForKeypath:(NSString *)keypath duration:(CGFloat)duration values:(NSArray *)values {
    [self addAnimationForKeypath:keypath delay:0 duration:duration values:values completion:nil];
}

-(void)addAnimationForKeypath:(NSString *)keypath duration:(CGFloat)duration values:(NSArray *)values completion:(void (^)(BOOL finished))completion {
    [self addAnimationForKeypath:keypath delay:0 duration:duration values:values completion:completion];
}

-(void)addAnimationForKeypath:(NSString *)keypath delay:(CGFloat)delay duration:(CGFloat)duration values:(NSArray *)values completion:(void (^)(BOOL finished))completion {
    if ([values count] < 2) {
        return;
    }

    [self setValue:values[0] forKeyPath:keypath];
    
	CAKeyframeBlocksAnimation *animation = [CAKeyframeBlocksAnimation animationWithKeyPath:keypath];
    animation.completion = completion;

    [animation setValues:values];
    animation.beginTime = CACurrentMediaTime()+delay;
	animation.duration = duration;

	[self addAnimation:animation forKey:[NSString stringWithFormat:@"%@Animation",keypath]];

    __weak CALayer *weakSelf = self;
    [animation setStart:^{
        [weakSelf setValue:[values lastObject] forKeyPath:keypath];
    }];
}

@end
