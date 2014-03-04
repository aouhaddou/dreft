//
//  CLLocation+DRExtensions.h
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

@import CoreLocation;

@interface CLLocation (DRExtensions)

-(CGPoint)dr_relativeMercatorCoordinate;
+(CLLocation *)dr_locationFromRelativeMercatorCoordinateWithX:(CGFloat)x y:(CGFloat)y;

-(CGFloat)dr_perpendicularDistanceWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation;
//-(CLLocation *)dr_perpendicularLocationWithLocation:(CLLocation *)firstLocation location:(CLLocation *)secondLocation;

@end
