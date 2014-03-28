//
//  DRDataProcessor.m
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDataProcessor.h"
#import "CLLocation+DRExtensions.h"
#import "DRDrift.h"

@interface DRDrift (Setters)

-(void)setDistance:(CGFloat)drift;
-(void)setLocation:(CLLocation *)location;
-(void)setLeg:(NSInteger)leg;
-(void)setDirection:(DRDriftDirection)direction;
-(void)setAngle:(CGFloat)angle;

@end

@implementation DRDataProcessor

-(id)initWithLocations:(NSArray *)locations {
    self = [super init];
    if (self) {
        BOOL onlyLocations = YES;
        NSInteger count = [self.locations count];

        for (NSInteger i = 0; i<count; i++) {
            id obj = locations[i];
            if (![obj isKindOfClass:CLLocation.class]) {
                onlyLocations = NO;
            }
        }

        if (onlyLocations) {
            _locations = locations;
        }
    }
    return self;
}

-(void)start {
    [[DRLocationManager sharedManager] addDelegate:self];
}

-(void)stop {
    [[DRLocationManager sharedManager] removeDelegate:self];
}

-(void)locationManager:(DRLocationManager *)locationManager didReceiveLocation:(CLLocation *)location {
    if ([self.delegate respondsToSelector:@selector(dataProcessor:didCalculateDrift:)]) {
        DRDrift *drift = [self minimumDriftForLocation:location];
        [self.delegate dataProcessor:self didCalculateDrift:drift];
    }
}

-(DRDrift *)minimumDriftForLocation:(CLLocation *)location {
    NSInteger count = [self.locations count];
    if (count == 0) {
        // No path, no distance
        return nil;
    } else if (count == 1) {
        //Only a point, distance to point
        CLLocation *point = self.locations.firstObject;
        CGFloat distance = [location distanceFromLocation:point];
        DRDrift *result = [DRDrift new];
        result.distance = distance;
        result.location = location;
        result.leg = -1;
        result.direction = DRDriftDirectionUnknown;
        return result;
    } else {
        //Check all path legs and return shortest distance
        CLLocationDistance minDrift = DBL_MAX;
        NSInteger leg = -1;
        CLLocation *p1;
        CLLocation *p2;
        CLLocation *r;

        for (NSInteger i = 0; i<count-1; i++) {
            CLLocation *point1 = self.locations[i];
            CLLocation *point2 = self.locations[i+1];
            CLLocation *perp = [location dr_perpendicularLocationWithLocation:point1 location:point2];
            CLLocationDistance drift = [location distanceFromLocation:perp];
            if (drift<minDrift) {
                minDrift = drift;
                leg = i;
                p1 = point1;
                p2 = point2;
                r = perp;
            }
        }

        DRDrift *result = [DRDrift new];
        result.distance = minDrift;
        result.location = location;
        result.leg = leg;

        //Calculate direction
        result.direction = [self directionForFirstPoint:p1 secondPoint:p2 currentPosition:location];

        //Calculate angle
        result.angle = [self angleForFirstPoint:p1 secondPoint:p2 currentPosition:location driftDirection:result.direction];

        return result;
    }
}

-(DRDriftDirection)directionForFirstPoint:(CLLocation *)first secondPoint:(CLLocation *)second currentPosition:(CLLocation *)position {
    if (!CLLocationCoordinate2DIsValid(first.coordinate) || !CLLocationCoordinate2DIsValid(second.coordinate) || !CLLocationCoordinate2DIsValid(position.coordinate)) {
        return DRDriftDirectionUnknown;
    }

    CGPoint a = [first dr_relativeMercatorCoordinate];
    CGPoint b = [second dr_relativeMercatorCoordinate];
    CGPoint c = [position dr_relativeMercatorCoordinate];

    CGFloat cross = ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x));

    if (cross == 0) {
        return DRDriftDirectionNoDrift;
    } else if (cross > 0) {
        return DRDriftDirectionLeft;
    } else {
        return DRDriftDirectionRight;
    }
}

-(CLLocationDirection)angleForFirstPoint:(CLLocation *)first secondPoint:(CLLocation *)second currentPosition:(CLLocation *)position driftDirection:(DRDriftDirection)direction {
    if (!CLLocationCoordinate2DIsValid(first.coordinate) || !CLLocationCoordinate2DIsValid(second.coordinate) || !CLLocationCoordinate2DIsValid(position.coordinate) || position.course < 0 || !(direction == DRDriftDirectionRight || direction == DRDriftDirectionLeft)) {
        return DRDriftNoAngle;
    }

    CLLocationDirection heading = [self headingForFirstPoint:first secondPoint:second];
    CLLocationDirection angle = heading - position.course;

    if (angle > 180) {
        angle -= 360;
    } else if (angle < -180) {
        angle += 360;
    }
    if (direction == DRDriftDirectionRight) {
        angle *= -1;
    }
    return angle;
}

-(CLLocationDirection)headingForFirstPoint:(CLLocation *)first secondPoint:(CLLocation *)second {
    CLLocationCoordinate2D coord1 = first.coordinate;
    CLLocationCoordinate2D coord2 = second.coordinate;

    CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
    CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
    CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));

    CLLocationDegrees radians = atan2(yComponent, xComponent);
    CLLocationDegrees degrees = radians*180/M_PI + 360;

    CLLocationDirection heading = fmod(degrees, 360);

    return heading;
}

-(void)locationManager:(DRLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(dataProcessor:didFailWithError:)]) {
        [self.delegate dataProcessor:self didFailWithError:error];
    }
}

@end
