//
//  DRSpeaker.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRSpeaker.h"

@implementation DRSpeaker

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(28.0, 40.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = self.color;

    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
    [rectanglePath moveToPoint: CGPointMake(0, 30)];
    [rectanglePath addLineToPoint: CGPointMake(14, 30)];
    [rectanglePath addLineToPoint: CGPointMake(28, 40)];
    [rectanglePath addLineToPoint: CGPointMake(28, 0)];
    [rectanglePath addLineToPoint: CGPointMake(14, 10)];
    [rectanglePath addLineToPoint: CGPointMake(0, 10)];
    [rectanglePath addLineToPoint: CGPointMake(0, 30)];
    [rectanglePath closePath];
    [color setFill];
    [rectanglePath fill];
}

@end
