//
//  CLLocation+DRExtensions.m
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "CLLocation+DRExtensions.h"

static const CGFloat r = 6378137.f;
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
    CGFloat result = fabs((M_PI_2-TOPooi))*r;

    return result;
}

-(GLKVector3)cartesianVector {
    CGFloat lat = self.coordinate.latitude;
    CGFloat lon = self.coordinate.longitude;

    GLKVector3 vec = GLKVector3Make(r*cos([self longitudeTo2Pi:lon])*sin([self colatitude:lat]),
                                     r*sin([self longitudeTo2Pi:lon])*sin([self colatitude:lat]),
                                     r*cos([self colatitude:lat]));

    return vec;
}

-(CGFloat)longitudeTo2Pi:(CGFloat)longitude {
    if (longitude < 0) {
        return [self toRadians:360.f+longitude];
    }
    return [self toRadians:longitude];
}

-(CGFloat)colatitude:(CGFloat)latitude {
    return [self toRadians:90.f-latitude];
}

-(CGFloat)toRadians:(CGFloat)degrees {
    return degrees*M_PI/180.f;
}

- (NSDecimalNumber *)absoluteValueOfDecimalNumber:(NSDecimalNumber *)num {
    if ([num compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
        // Number is negative. Multiply by -1
        NSDecimalNumber * negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1
                                                                          exponent:0
                                                                        isNegative:YES];
        return [num decimalNumberByMultiplyingBy:negativeOne];
    } else {
        return num;
    }
}

//-(CLLocation *)dr_perpendicularLocationWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation {
//    return secondLocation;
//}

@end
