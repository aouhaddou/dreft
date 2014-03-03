//
//  BRBackArrow.m
//  Datalove
//
//  Created by Christoph on 4/6/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRBackArrow.h"

@implementation BRBackArrow

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(26.0, 25.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = self.color;

    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(22, 12.5)];
    [bezier2Path addLineToPoint: CGPointMake(7, 12.5)];
    [strokeColor setStroke];
    bezier2Path.lineWidth = 3;
    [bezier2Path stroke];


    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(12.5, 6)];
    [bezier3Path addLineToPoint: CGPointMake(6, 12.5)];
    [bezier3Path addLineToPoint: CGPointMake(12.5, 19)];
    bezier3Path.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezier3Path.lineWidth = 3;
    [bezier3Path stroke];
}


@end
