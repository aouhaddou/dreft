//
//  CALayer+KeyframeAnimations.h
//  Datalove
//
//  Created by Christoph on 3/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeBlocksAnimation : CAKeyframeAnimation

@property (nonatomic, copy) void (^completion)(BOOL finished);
@property (nonatomic, copy) void (^start)(void);

@end

@interface CALayer (KeyframeAnimations)

-(void)addAnimationForKeypath:(NSString *)keypath duration:(CGFloat)duration values:(NSArray *)values;
-(void)addAnimationForKeypath:(NSString *)keypath duration:(CGFloat)duration values:(NSArray *)values completion:(void (^)(BOOL finished))completion;
-(void)addAnimationForKeypath:(NSString *)keypath delay:(CGFloat)delay duration:(CGFloat)duration values:(NSArray *)values completion:(void (^)(BOOL finished))completion;

@end
