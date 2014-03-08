//
//  BRSettingsIcon.m
//  Datalove
//
//  Created by Christoph on 4/22/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRSettingsIcon.h"

@implementation BRSettingsIcon

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(25.0, 25.0);
    return [super initWithColor:color];
}

-(void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* strokeColor = self.color;

    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(14.3, 6.2)];
    [bezier2Path addLineToPoint: CGPointMake(15.65, 6.65)];
    [bezier2Path addLineToPoint: CGPointMake(17.9, 5.3)];
    [bezier2Path addLineToPoint: CGPointMake(19.7, 7.1)];
    [bezier2Path addLineToPoint: CGPointMake(18.35, 9.35)];
    [bezier2Path addLineToPoint: CGPointMake(18.8, 10.7)];
    [bezier2Path addLineToPoint: CGPointMake(21.5, 11.15)];
    [bezier2Path addLineToPoint: CGPointMake(21.5, 13.85)];
    [bezier2Path addLineToPoint: CGPointMake(18.8, 14.3)];
    [bezier2Path addLineToPoint: CGPointMake(18.35, 15.65)];
    [bezier2Path addLineToPoint: CGPointMake(19.7, 17.9)];
    [bezier2Path addLineToPoint: CGPointMake(17.9, 19.7)];
    [bezier2Path addLineToPoint: CGPointMake(15.65, 18.35)];
    [bezier2Path addLineToPoint: CGPointMake(14.3, 18.8)];
    [bezier2Path addLineToPoint: CGPointMake(13.85, 21.5)];
    [bezier2Path addLineToPoint: CGPointMake(11.15, 21.5)];
    [bezier2Path addLineToPoint: CGPointMake(10.7, 18.8)];
    [bezier2Path addLineToPoint: CGPointMake(9.35, 18.35)];
    [bezier2Path addLineToPoint: CGPointMake(7.1, 19.7)];
    [bezier2Path addLineToPoint: CGPointMake(5.3, 17.9)];
    [bezier2Path addLineToPoint: CGPointMake(6.65, 15.65)];
    [bezier2Path addLineToPoint: CGPointMake(6.2, 14.3)];
    [bezier2Path addLineToPoint: CGPointMake(3.5, 13.85)];
    [bezier2Path addLineToPoint: CGPointMake(3.5, 11.15)];
    [bezier2Path addLineToPoint: CGPointMake(6.2, 10.7)];
    [bezier2Path addLineToPoint: CGPointMake(6.65, 9.35)];
    [bezier2Path addLineToPoint: CGPointMake(5.3, 7.1)];
    [bezier2Path addLineToPoint: CGPointMake(7.1, 5.3)];
    [bezier2Path addLineToPoint: CGPointMake(9.35, 6.65)];
    [bezier2Path addLineToPoint: CGPointMake(10.7, 6.2)];
    [bezier2Path addLineToPoint: CGPointMake(11.15, 3.5)];
    [bezier2Path addLineToPoint: CGPointMake(13.85, 3.5)];
    [bezier2Path addLineToPoint: CGPointMake(14.3, 6.2)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(9.95, 9.95)];
    [bezier2Path addCurveToPoint: CGPointMake(9.95, 15.05) controlPoint1: CGPointMake(8.55, 11.36) controlPoint2: CGPointMake(8.55, 13.64)];
    [bezier2Path addCurveToPoint: CGPointMake(15.05, 15.05) controlPoint1: CGPointMake(11.36, 16.45) controlPoint2: CGPointMake(13.64, 16.45)];
    [bezier2Path addCurveToPoint: CGPointMake(15.05, 9.95) controlPoint1: CGPointMake(16.45, 13.64) controlPoint2: CGPointMake(16.45, 11.36)];
    [bezier2Path addCurveToPoint: CGPointMake(9.95, 9.95) controlPoint1: CGPointMake(13.64, 8.55) controlPoint2: CGPointMake(11.36, 8.55)];
    [bezier2Path closePath];
    [strokeColor setFill];
    [bezier2Path fill];
}

@end
