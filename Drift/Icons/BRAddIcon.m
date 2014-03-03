//
//  BRAddIcon.m
//  Datalove
//
//  Created by Christoph on 4/3/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRAddIcon.h"

@implementation BRAddIcon

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(22.0, 22.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = self.color;

    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(11, 5)];
    [bezierPath addLineToPoint: CGPointMake(11, 17)];
    bezierPath.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezierPath.lineWidth = 3;
    [bezierPath stroke];


    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(5, 11)];
    [bezier2Path addLineToPoint: CGPointMake(17, 11)];
    bezier2Path.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezier2Path.lineWidth = 3;
    [bezier2Path stroke];
}


@end
