//
//  BRDisclosureView.m
//  Datalove
//
//  Created by Christoph on 3/27/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRDisclosureIcon.h"

@implementation BRDisclosureIcon

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(10.0, 14.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColor = self.color;

    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(1, 11)];
    [bezierPath addLineToPoint: CGPointMake(5, 7)];
    [bezierPath addLineToPoint: CGPointMake(1, 3)];
    [bezierPath addLineToPoint: CGPointMake(3, 1)];
    [bezierPath addLineToPoint: CGPointMake(9, 7)];
    [bezierPath addLineToPoint: CGPointMake(3, 13)];
    [bezierPath addLineToPoint: CGPointMake(1, 11)];
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
}

@end
