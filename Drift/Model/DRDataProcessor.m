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

        for (NSInteger i = 0; i<count-1; i++) {
            CLLocation *point1 = self.locations[i];
            CLLocation *point2 = self.locations[i+1];

            CLLocationDistance drift = [location dr_perpendicularDistanceWithLocation:point1 location:point2];
            if (drift<minDrift) {
                minDrift = drift;
                leg = i;
            }
        }
        DRDrift *result = [DRDrift new];
        result.distance = minDrift;
        result.location = location;
        result.leg = leg;

        //Calculate direction
        CLLocation *l1 = self.locations[leg];
        CLLocation *l2 = self.locations[leg+1];
        result.direction = [self directionForFirstPoint:l1 secondPoint:l2 currentPosition:location];

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

-(void)locationManager:(DRLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(dataProcessor:didFailWithError:)]) {
        [self.delegate dataProcessor:self didFailWithError:error];
    }
}

@end
