//
//  DRCountdownCircle.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRCountdownCircle.h"

static CGFloat const lineWidth = 20;
static CGFloat const strokeStart = 0;
static CGFloat const strokeEnd = 1;

@interface DRCountdownCircle()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation DRCountdownCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windupDuration = 1;
        self.countdownDuration = [[DRVariableManager sharedManager] baseRateForAcousticFeedback]-self.windupDuration;

        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.strokeColor = [DRTheme base4].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = lineWidth;

        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth/2, lineWidth/2, self.width-lineWidth, self.width-lineWidth)];
        layer.path = path.CGPath;
        layer.strokeStart = strokeStart;
        layer.strokeEnd = strokeStart;

        [self.layer addSublayer:layer];
        self.shapeLayer = layer;

        self.transform = CGAffineTransformMakeRotation(-90.f*M_PI/180.f);
    }
    return self;
}

-(void)start {
    [self animateUp];
}

-(void)animateUp {
    self.shapeLayer.strokeEnd = strokeEnd;
    CABasicAnimation *up = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    up.delegate = self;
    [up setValue:@"animationup" forKey:@"id"];
    up.duration = self.windupDuration;
    up.fromValue = @(strokeStart);
    up.toValue = @(strokeEnd);
    up.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:up forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"id"] isEqual:@"animationup"] && flag) {
        self.shapeLayer.strokeEnd = strokeStart;
        CABasicAnimation *up = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        up.duration = self.countdownDuration;
        up.fromValue = @(strokeEnd);
        up.toValue = @(strokeStart);
        up.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.shapeLayer addAnimation:up forKey:nil];
    }
}

@end
