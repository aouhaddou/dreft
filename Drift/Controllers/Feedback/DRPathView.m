//
//  DRPathView.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathView.h"
#import "NSArray+DRExtensions.h"
#import "CLLocation+DRExtensions.h"

@implementation DRPathView

-(void)setPrimaryLocations:(NSArray *)primaryLocations {
    _primaryLocations = [primaryLocations dr_convertCLLocationsToRelativeMercatorPoints];
    [self setNeedsDisplay];
}

-(void)setSecondaryLocations:(NSArray *)secondaryLocations {
    _secondaryLocations = [secondaryLocations dr_convertCLLocationsToRelativeMercatorPoints];
    [self setNeedsDisplay];
}

-(void)setMarksEndOfPrimaryLine:(BOOL)marksEndOfPrimaryLine {
    _marksEndOfPrimaryLine = marksEndOfPrimaryLine;
    [self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSArray *allPoints;
    if ([self.primaryLocations count] > 0) {
        allPoints = [self.primaryLocations arrayByAddingObjectsFromArray:self.secondaryLocations];
    } else if ([self.secondaryLocations count] > 0) {
        allPoints = self.secondaryLocations;
    } else {
        return;
    }

    if (self.lineWidth < 1) {
        self.lineWidth = 1;
    }

    NSArray *results = [allPoints dr_zoomRelativeCoordinatesWithHorizontalAlignment:self.horizontalAlignment verticalAlignment:self.verticalAlignment];

    NSRange primaryRange;
    primaryRange.location = 0;
    primaryRange.length = [self.primaryLocations count];
    NSArray *primary = [results subarrayWithRange:primaryRange];

    NSRange secondaryRange;
    secondaryRange.location = primaryRange.length;
    secondaryRange.length = [results count]-primaryRange.length;
    NSArray *secondary = [results subarrayWithRange:secondaryRange];

    [self drawLineWithArray:secondary color:self.secondaryLineColor];

    if (self.marksEndOfPrimaryLine && [self.primaryLocations count] > 0) {
        CGPoint point = [[primary lastObject] CGPointValue];
        CGPoint viewPoint = [self pointInViewForRelativePoint:point];
        CGFloat bigRadius = 24;
        CGFloat smallRadius = 12;

        UIBezierPath *bigCircle = [self bezierPathForCircleWithRadius:bigRadius atPoint:viewPoint];
        bigCircle.lineWidth = 3;
        [self.primaryLineColor setStroke];
        [bigCircle stroke];

        UIBezierPath *smallCircle = [self bezierPathForCircleWithRadius:smallRadius atPoint:viewPoint];
        [self.primaryLineColor setFill];
        [smallCircle fill];
    }

    [self drawLineWithArray:primary color:self.primaryLineColor];
}

-(void)drawLineWithArray:(NSArray *)points color:(UIColor *)color {
    UIColor *drawColor = color;
    if (color == nil) {
        drawColor = [DRTheme base4];
    }
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
        [drawColor setStroke];
        bezierPath.lineWidth = self.lineWidth;
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
