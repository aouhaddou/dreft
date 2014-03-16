//
//  DRCheckpointAnnotation.m
//  Drift
//
//  Created by Christoph Albert on 3/16/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRCheckpointAnnotation.h"

@implementation DRCheckpointAnnotation

- (id)initWithColor:(UIColor *)color {
    self.size = CGSizeMake(50.0, 50.0);
    return [super initWithColor:color];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = self.color;

    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 46, 46)];
    [color setStroke];
    ovalPath.lineWidth = 3;
    [ovalPath stroke];


    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(20, 20, 10, 10)];
    [color setFill];
    [oval2Path fill];
}

@end
