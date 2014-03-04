//
//  DRPathView.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathView.h"
#import "NSArray+DRExtensions.h"

@implementation DRPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPrimaryPoints:(NSArray *)primaryPoints {
    _primaryPoints = [primaryPoints dr_convertCLLocationsToRelativeMercatorPoints];
    [self setNeedsDisplay];
}

-(void)setSecondaryPoints:(NSArray *)secondaryPoints {
    _secondaryPoints = [secondaryPoints dr_convertCLLocationsToRelativeMercatorPoints];
    [self setNeedsDisplay];
}

-(void)setMarksEndOfPrimaryLine:(BOOL)marksEndOfPrimaryLine {
    _marksEndOfPrimaryLine = marksEndOfPrimaryLine;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if ([self.secondaryPoints count] > 1) {
        if ([self.primaryPoints count] > 0) {
            NSArray *allPoints = [self.primaryPoints arrayByAddingObjectsFromArray:self.secondaryPoints];
            NSArray *results = [allPoints dr_zoomRelativeCoordinatesWithHorizontalAlignment:NSArrayRelativePointsHorizontalAlignmentCenter verticalAlignment:NSArrayRelativePointsVerticalAlignmentCenter];

            NSRange primaryRange;
            primaryRange.location = 0;
            primaryRange.length = [self.primaryPoints count];
            NSArray *primary = [results subarrayWithRange:primaryRange];

            NSRange secondaryRange;
            secondaryRange.location = primaryRange.length;
            secondaryRange.length = [results count]-primaryRange.length;
            NSArray *secondary = [results subarrayWithRange:secondaryRange];

            [self drawLineWithArray:secondary color:[DRTheme transparentBase4]];

            if (self.marksEndOfPrimaryLine) {
                CGPoint point = [[primary lastObject] CGPointValue];
                CGPoint viewPoint = [self pointInViewForRelativePoint:point];
                CGFloat bigRadius = 24.f;
                CGFloat smallRadius = 12.f;

                UIBezierPath *bigCircle = [self bezierPathForCircleWithRadius:bigRadius atPoint:viewPoint];
                bigCircle.lineWidth = 3.f;
                [[DRTheme base4] setStroke];
                [bigCircle stroke];

                UIBezierPath *smallCircle = [self bezierPathForCircleWithRadius:smallRadius atPoint:viewPoint];
                [[DRTheme base4] setFill];
                [smallCircle fill];
            }

            [self drawLineWithArray:primary color:[DRTheme base4]];
        } else {
            NSArray *results = [self.secondaryPoints dr_zoomRelativeCoordinatesWithHorizontalAlignment:NSArrayRelativePointsHorizontalAlignmentCenter verticalAlignment:NSArrayRelativePointsVerticalAlignmentCenter];

            [self drawLineWithArray:results color:[DRTheme transparentBase4]];
        }
    }
}

-(void)drawLineWithArray:(NSArray *)points color:(UIColor *)color {
    if ([points count] > 1) {
        //// Bezier Drawing
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        BOOL moved = NO;

        for (NSValue *value in points) {
            CGPoint point = [value CGPointValue];
            CGPoint viewPoint = [self pointInViewForRelativePoint:point];
            if (!moved) {
                moved = YES;
                [bezierPath moveToPoint:viewPoint];
            } else {
                [bezierPath addLineToPoint:viewPoint];
            }
        }

        bezierPath.lineCapStyle = kCGLineCapRound;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        [color setStroke];
        bezierPath.lineWidth = 4.f;
        [bezierPath stroke];
    }
}

-(UIBezierPath *)bezierPathForCircleWithRadius:(CGFloat)radius atPoint:(CGPoint)point {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x-radius/2.f, point.y-radius/2.f, radius, radius)];
}

-(CGPoint)pointInViewForRelativePoint:(CGPoint)point {
    CGFloat margin = self.marksEndOfPrimaryLine ? 16.f : 5.f;
    return CGPointMake(margin+point.x*(self.width-2*margin), margin+point.y*(self.height-2*margin));
}

@end
