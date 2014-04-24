//
//  NSArray+DRExtensions.m
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "NSArray+DRExtensions.h"
#import "CLLocation+DRExtensions.h"

@implementation NSArray (DRExtensions)

-(NSArray *)dr_convertCLLocationsToRelativeMercatorPoints {
    NSUInteger count = self.count;

    NSMutableArray *points = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i<count; i++) {
        id obj = self[i];
        if (![obj isKindOfClass:[CLLocation class]]) {
            //Contains something that is not a CLLocation
            return nil;
        }

        CGPoint point = [(CLLocation *)obj dr_relativeMercatorCoordinate];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }

    return points;
}

-(NSArray *)dr_zoomRelativeCoordinatesWithHorizontalAlignment:(NSArrayRelativePointsHorizontalAlignment)horizontalAlignment verticalAlignment:(NSArrayRelativePointsVerticalAlignment)verticalAlignment {

    CGFloat smallestXVal = 1;
    CGFloat biggestXVal = 0;

    CGFloat smallestYVal = 1;
    CGFloat biggestYVal = 0;

    NSUInteger count = self.count;

    for (NSUInteger i = 0; i<count; i++) {
        id obj = self[i];
        if (![obj isKindOfClass:[NSValue class]]) {
            //Contains something that is not a point
            return nil;
        }

        CGPoint rel = [(NSValue *)obj CGPointValue];
        if (rel.x < 0 || rel.x > 1 || rel.y < 0 || rel.y > 1) {
            //Point not relative
            return nil;
        }

        if (rel.x < smallestXVal) {
            smallestXVal = rel.x;
        }
        if (rel.y < smallestYVal) {
            smallestYVal = rel.y;
        }

        if (rel.x > biggestXVal) {
            biggestXVal = rel.x;
        }
        if (rel.y > biggestYVal) {
            biggestYVal = rel.y;
        }
    }

    CGFloat dX = biggestXVal-smallestXVal;
    CGFloat dY = biggestYVal-smallestYVal;
    CGFloat align;

    if (dX == 0 && dY == 0) {
        return nil;
    }

    if (dX > dY) {
        switch (verticalAlignment) {
            case NSArrayRelativePointsVerticalAlignmentTop:
                align = 0;
                break;
            case NSArrayRelativePointsVerticalAlignmentCenter:
                align = (dX-dY)/dX/2;
                break;
            case NSArrayRelativePointsVerticalAlignmentBottom:
                align = (dX-dY)/dX;
                break;
            default:
                break;
        }
    } else {
        switch (horizontalAlignment) {
            case NSArrayRelativePointsHorizontalAlignmentLeft:
                align = 0;
                break;
            case NSArrayRelativePointsHorizontalAlignmentCenter:
                align = (dY-dX)/dY/2;
                break;
            case NSArrayRelativePointsHorizontalAlignmentRight:
                align = (dY-dX)/dY;
                break;
            default:
                break;
        }
    }

    NSMutableArray *zoomedPoints = [[NSMutableArray alloc] init];
    for (NSValue *value in self) {
        CGPoint point = [value CGPointValue];
        CGPoint zoomed;
        if (dX > dY) {
            zoomed = CGPointMake((point.x-smallestXVal)/dX, align + (point.y-smallestYVal)/dX);
        } else {
            zoomed = CGPointMake(align + (point.x-smallestXVal)/dY, (point.y-smallestYVal)/dY);
        }
        [zoomedPoints addObject:[NSValue valueWithCGPoint:zoomed]];
    }
    return zoomedPoints;
}

@end
