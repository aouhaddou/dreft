//
//  CLLocation+DRExtensions.m
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "CLLocation+DRExtensions.h"

float const kEarthRadius = 6367500.f;

float degreesToRadians(float angle) {
    return ((angle) / 180.f * M_PI);
}

@import GLKit;

@implementation CLLocation (DRExtensions)

-(CGPoint)dr_relativeMercatorCoordinate {
    CGFloat width = 1.f;
    CGFloat height = 1.f;

    CGFloat x = (self.coordinate.longitude+180.f)*(width/360.f);
    CGFloat y = (height/2.f)-(width*log(tan((M_PI/4.f)+((self.coordinate.latitude*M_PI/180.f)/2.f)))/(2.f*M_PI));

    return CGPointMake(x, y);
}

-(CGFloat)dr_perpendicularDistanceWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
    //http://biodiversityinformatics.amnh.org/open_source/pdc/documentation.php
    GLKVector3 vec1 = [firstLocation cartesianVector];
    GLKVector3 vec2 = [secondLocation cartesianVector];
    GLKVector3 P = [self cartesianVector];

    GLKVector3 cross = GLKVector3CrossProduct(vec1, vec2);
    GLKVector3 T = GLKVector3Normalize(cross);

    CGFloat cosTOPooi = GLKVector3DotProduct(T, P)/GLKVector3Length(P);
    CGFloat TOPooi = acos(cosTOPooi);
    CGFloat result = fabs((M_PI_2-TOPooi))*kEarthRadius;

    return result;
}

-(GLKVector3)cartesianVector {
    CGFloat lat = self.coordinate.latitude;
    CGFloat lon = self.coordinate.longitude;

    GLKVector3 vec = GLKVector3Make(kEarthRadius*cos([self longitudeTo2Pi:lon])*sin([self colatitude:lat]),
                                     kEarthRadius*sin([self longitudeTo2Pi:lon])*sin([self colatitude:lat]),
                                     kEarthRadius*cos([self colatitude:lat]));

    return vec;
}

-(CGFloat)longitudeTo2Pi:(CGFloat)longitude {
    if (longitude < 0) {
        return degreesToRadians(360.f+longitude);
    }
    return degreesToRadians(longitude);
}

-(CGFloat)colatitude:(CGFloat)latitude {
    return degreesToRadians(90.f-latitude);
}

//-(CLLocation *)dr_perpendicularLocationWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
//    return secondLocation;
//}

@end
