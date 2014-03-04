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
    CGFloat y = (height/2.f)-(width*log(tan((M_PI/4.f)+(self.coordinate.latitude*M_PI/360.f)))/(2.f*M_PI));

    return CGPointMake(x, y);
}

+(CLLocation *)dr_locationFromRelativeMercatorCoordinateWithX:(CGFloat)x y:(CGFloat)y {
    CGFloat width = 1.f;
    CGFloat height = 1.f;

    CGFloat lon = x/(width/360.f)-180.f;
    CGFloat lat = (atan(exp((2.f*M_PI)*(-y+(height/2.f))/width))-(M_PI/4.f))*360.f/M_PI;

    return [[CLLocation alloc] initWithLatitude:lat longitude:lon];
}

-(CGFloat)dr_perpendicularDistanceWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
    //http://biodiversityinformatics.amnh.org/open_source/pdc/documentation.php
    GLKVector3 vec1 = [firstLocation dr_cartesianVector];
    GLKVector3 vec2 = [secondLocation dr_cartesianVector];
    GLKVector3 P = [self dr_cartesianVector];

    GLKVector3 cross = GLKVector3CrossProduct(vec1, vec2);
    GLKVector3 T = GLKVector3Normalize(cross);

    CGFloat cosTOPooi = GLKVector3DotProduct(T, P)/GLKVector3Length(P);
    CGFloat TOPooi = acos(cosTOPooi);
    CGFloat result = fabs((M_PI_2-TOPooi))*kWGS84Radius;

    return result;
}

-(GLKVector3)dr_cartesianVector {
    CGFloat lat = self.coordinate.latitude;
    CGFloat lon = self.coordinate.longitude;

    GLKVector3 vec = GLKVector3Make(kWGS84Radius*cos([self dr_longitudeTo2Pi:lon])*sin([self dr_colatitude:lat]),
                                     kWGS84Radius*sin([self dr_longitudeTo2Pi:lon])*sin([self dr_colatitude:lat]),
                                     kWGS84Radius*cos([self dr_colatitude:lat]));

    return vec;
}

-(CGFloat)dr_longitudeTo2Pi:(CGFloat)longitude {
    if (longitude < 0) {
        return degreesToRadians(360.f+longitude);
    }
    return degreesToRadians(longitude);
}

-(CGFloat)dr_colatitude:(CGFloat)latitude {
    return degreesToRadians(90.f-latitude);
}

-(CLLocation *)dr_perpendicularLocationWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
    CGPoint P = [self dr_relativeMercatorCoordinate];

    CGPoint T1 = [firstLocation dr_relativeMercatorCoordinate];
    CGPoint T2 = [secondLocation dr_relativeMercatorCoordinate];

    //Linear Equation for T1, T2
    CGFloat aT = (T1.y-T2.y)/(T1.x-T2.x);
    CGFloat nT = T1.y-aT*T1.x;

    CGFloat aP = -1.f/aT;
    CGFloat nP = P.y-aP*P.x;

    CGFloat rX = (nP-nT)/(aT-aP);
    CGFloat rY = aP*rX+nP;

    return [CLLocation dr_locationFromRelativeMercatorCoordinateWithX:rX y:rY];
}

@end
