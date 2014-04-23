//
//  DRDriftView.m
//  Drift
//
//  Created by Christoph Albert on 3/27/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDriftView.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const locationRadius = 40;
CGFloat const locationThickness = 14;
CGFloat const destinationRadius = 17;
CGFloat const lineWidth = 4;

BOOL const rotate = NO;

@interface DRDriftView() {
    CGPoint _locCenter;
    CGPoint _desCenter;
}

@property (nonatomic, strong) CAShapeLayer *location;
@property (nonatomic, strong) CAShapeLayer *destination;
@property (nonatomic, strong) CAShapeLayer *line;

@end

@implementation DRDriftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [DRTheme backgroundColor];

        _locCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
        _desCenter = _locCenter;

        CAShapeLayer *line = [[CAShapeLayer alloc] init];
        line.path = [self linePath].CGPath;
        line.strokeColor = [DRTheme base4].CGColor;
        line.lineWidth = lineWidth;
        self.line = line;
        [self.layer addSublayer:self.line];

        CAShapeLayer *loc = [[CAShapeLayer alloc] init];
        loc.path = [self bezierPathForCircleWithRadius:locationRadius atPoint:_locCenter].CGPath;
        loc.strokeColor = [DRTheme base4].CGColor;
        loc.lineWidth = locationThickness;
        loc.fillColor = [DRTheme backgroundColor].CGColor;
        self.location = loc;
        [self.layer addSublayer:self.location];

        CAShapeLayer *des = [[CAShapeLayer alloc] init];
        des.path = [self bezierPathForCircleWithRadius:destinationRadius atPoint:_desCenter].CGPath;
        des.fillColor = [DRTheme base4].CGColor;
        self.destination = des;
        [self.layer addSublayer:self.destination];
    }
    return self;
}

-(UIBezierPath *)bezierPathForCircleWithRadius:(CGFloat)radius atPoint:(CGPoint)point {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-radius, point.y-radius, radius*2, radius*2)];
}

-(void)setDrift:(DRDrift *)drift {
    CGAffineTransform old = self.transform;
    self.transform = CGAffineTransformIdentity;

    _drift = drift;

    _locCenter = CGPointMake([self xPosForDrift:drift margin:locationRadius+locationThickness/2 reverse:NO], self.height/2);
    CGPathRef newLoc = [self bezierPathForCircleWithRadius:locationRadius atPoint:_locCenter].CGPath;
    [self animateNewPath:newLoc ofLayer:self.location];

    _desCenter = CGPointMake([self xPosForDrift:drift margin:locationRadius reverse:YES], self.height/2);
    CGPathRef newDes = [self bezierPathForCircleWithRadius:destinationRadius atPoint:_desCenter].CGPath;
    [self animateNewPath:newDes ofLayer:self.destination];

    CGPathRef newLine = [self linePath].CGPath;
    [self animateNewPath:newLine ofLayer:self.line];

    if (rotate) {
        self.transform = old;
        [UIView animateWithDuration:0.5 animations:^{
            if (drift.angle == DRDriftNoAngle) {
                self.transform = CGAffineTransformIdentity;
            } else {
                CLLocationDegrees deg = drift.angle;

                //Small ranges graphically less severe
                CGFloat factor = 1.6;
                if (deg >= 0 && deg < 90) {
                    deg = pow(deg/90,factor)*90;
                } else if (deg < 0 && deg > -90) {
                    deg = -pow(fabs(deg)/90,factor)*90;
                }

                if (drift.direction == DRDriftDirectionLeft) {
                    self.transform = CGAffineTransformMakeRotation(deg*M_PI/180);
                } else {
                    self.transform = CGAffineTransformMakeRotation(-deg*M_PI/180);
                }
            }
        }];
    }
}

-(void)animateNewPath:(CGPathRef)path ofLayer:(CAShapeLayer *)layer {
    CGPathRef oldPath = layer.path;
    layer.path = path;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.5f;
    animation.fromValue = (__bridge id)oldPath;
    animation.toValue = (__bridge id)path;
    [layer addAnimation:animation forKey:@"path"];
}

-(CGFloat)xPosForDrift:(DRDrift *)drift margin:(CGFloat)margin reverse:(BOOL)reverse {
    CGFloat relOffset = MIN(1, sqrt(drift.distance/[[DRVariableManager sharedManager] zone2Thresh]));
    if (drift.direction == DRDriftDirectionRight) {
        return interpolate(self.centerX, reverse ? margin : self.width-margin, relOffset);
    } else {
        return interpolate(self.centerX, reverse ? self.width-margin : margin, relOffset);
    }
}

-(UIBezierPath *)linePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_locCenter];
    [path addLineToPoint:_desCenter];
    path.lineCapStyle = kCGLineCapRound;
    return path;
}

double interpolate(double a, double b, double t)
{
    return a + (b - a) * t;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
