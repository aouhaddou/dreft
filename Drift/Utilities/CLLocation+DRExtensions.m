//
//  CLLocation+DRExtensions.m
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "CLLocation+DRExtensions.h"

float const kWGS84Radius = 6378137.f;

float degreesToRadians(float angle) {
    return ((angle) / 180.f * M_PI);
}

@import GLKit;

@implementation CLLocation (DRExtensions)

-(CGPoint)dr_relativeMercatorCoordinate {
    CGFloat width = 1.f;
    CGFloat height = 1.f;

    CGFloat x = (self.coordinate.longitude+180.f)*(width/360.f);
    CGFloat y = (height/2.f)+(width*log(tan((M_PI/4.f)+(self.coordinate.latitude*M_PI/360.f)))/(2.f*M_PI));

    return CGPointMake(x, y);
}

+(CLLocation *)dr_locationFromRelativeMercatorCoordinateWithX:(CGFloat)x y:(CGFloat)y {
    CGFloat width = 1.f;
    CGFloat height = 1.f;

    CGFloat lon = x/(width/360.f)-180.f;
    CGFloat lat = (atan(exp((2.f*M_PI)*(y-(height/2.f))/width))-(M_PI/4.f))*360.f/M_PI;

    return [[CLLocation alloc] initWithLatitude:lat longitude:lon];
}

-(CGFloat)dr_perpendicularDistanceWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
    CLLocation *perp = [self dr_perpendicularLocationWithLocation:firstLocation location:secondLocation];
    return [self distanceFromLocation:perp];
}

-(CLLocation *)dr_perpendicularLocationWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
    //Project points into 2 dimensional plance using mercator projection
    CGPoint P = [self dr_relativeMercatorCoordinate];

    CGPoint T1 = [firstLocation dr_relativeMercatorCoordinate];
    CGPoint T2 = [secondLocation dr_relativeMercatorCoordinate];

    //Calculate Perpendicular Point
    CGPoint R;

    //Check for special cases
    if (T1.x == T2.x) {
        //aT infinite because line is vertical
        //Perpendicular is horizontal
        R = CGPointMake(T1.x, P.y);
    } else if (T1.y == T2.y) {
        //aT 0 because line is horizontal
        //Perpendicular is vertical
        R = CGPointMake(P.x, T1.y);
    } else {
        //Linear Equation for T1, T2
        CGFloat aT = (T1.y-T2.y)/(T1.x-T2.x);
        CGFloat nT = T1.y-aT*T1.x;

        CGFloat aP = -1.f/aT;
        CGFloat nP = P.y-aP*P.x;

        CGFloat rX = (nP-nT)/(aT-aP);
        CGFloat rY = aP*rX+nP;

        R = CGPointMake(rX, rY);
    }

    //Check if R is on line segment
    BOOL yInRange = NO;
    BOOL xInRange = NO;

    if (T1.y <= T2.y) {
        yInRange = T1.y <= R.y && R.y <= T2.y;
    } else {
        yInRange = T2.y <= R.y && R.y <= T1.y;
    }
    if (T1.x <= T2.x) {
        xInRange = T1.x <= R.x && R.x <= T2.x;
    } else {
        xInRange = T2.x <= R.x && R.x <= T1.x;
    }

    if (yInRange && xInRange) {
        return [CLLocation dr_locationFromRelativeMercatorCoordinateWithX:R.x y:R.y];
    } else {
        //Find nearest corner
        CGFloat d1 = [self distanceFromLocation:firstLocation];
        CGFloat d2 = [self distanceFromLocation:secondLocation];
        if (d1 <= d2) {
            return firstLocation;
        } else {
            return secondLocation;
        }
    }
}

@end
