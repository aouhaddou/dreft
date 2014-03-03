//
//  BRCheckmarkIcon.m
//  Datalove
//
//  Created by Christoph on 6/4/13.
//  Copyright (c) 2013 chrisalbert. All rights reserved.
//

#import "BRCheckmarkIcon.h"

@implementation BRCheckmarkIcon

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(25.0, 25.0);
    return [super initWithColor:color];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = self.color;

    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(6.5, 13.5)];
    [bezierPath addLineToPoint: CGPointMake(10, 17)];
    [bezierPath addLineToPoint: CGPointMake(19, 8)];
    bezierPath.lineCapStyle = kCGLineCapSquare;

    [strokeColor setStroke];
    bezierPath.lineWidth = 3;
    [bezierPath stroke];
}


@end
