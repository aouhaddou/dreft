//
//  BRCancelIcon.m
//  Datalove
//
//  Created by Christoph on 4/19/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRCancelIcon.h"

@implementation BRCancelIcon

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(25.0, 25.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = self.color;

    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(7.5, 17.5)];
    [bezierPath addLineToPoint: CGPointMake(17.5, 7.5)];
    bezierPath.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezierPath.lineWidth = 3;
    [bezierPath stroke];


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(7.5, 7.5)];
    [bezier2Path addLineToPoint: CGPointMake(17.5, 17.5)];
    bezier2Path.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezier2Path.lineWidth = 3;
    [bezier2Path stroke];

}

@end
