//
//  DRDataProcessor.m
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDataProcessor.h"
#import "CLLocation+DRExtensions.h"

@interface DRDriftResult(Setters)

-(void)setDrift:(CGFloat)drift;
-(void)setLocation:(CLLocation *)location;
-(void)setLeg:(NSInteger)leg;
-(void)setDirection:(DRDriftDirection)direction;

@end

@implementation DRDriftResult

-(void)setDrift:(CGFloat)drift {
    _drift = drift;
}
-(void)setLocation:(CLLocation *)location {
    _location = location;
}
-(void)setLeg:(NSInteger)leg {
    _leg = leg;
}
-(void)setDirection:(DRDriftDirection)direction {
    _direction = direction;
}

@end

@implementation DRDataProcessor

-(id)initWithPath:(NSArray *)path {
    self = [super init];
    if (self) {
        BOOL onlyLocations = YES;
        NSInteger count = [self.path count];

        for (NSInteger i = 0; i<count; i++) {
            id obj = path[i];
            if (![obj isKindOfClass:CLLocation.class]) {
                onlyLocations = NO;
            }
        }

        if (onlyLocations) {
            _path = path;
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
        DRDriftResult *drift = [self minimumDriftForLocation:location];
        [self.delegate dataProcessor:self didCalculateDrift:drift];
    }
}

-(DRDriftResult *)minimumDriftForLocation:(CLLocation *)location {
    NSInteger count = [self.path count];
    if (count == 0) {
        // No path, no distance
        return nil;
    } else if (count == 1) {
        //Only a point, distance to point
        CLLocation *point = self.path.firstObject;
        CGFloat distance = [location distanceFromLocation:point];
        DRDriftResult *result = [DRDriftResult new];
        result.drift = distance;
        result.location = location;
        result.leg = -1;
        return result;
    } else {
        //Check all path legs and return shortest distance
        CLLocationDistance minDrift = DBL_MAX;
        CGFloat leg = -1;

        for (NSInteger i = 0; i<count-1; i++) {
            CLLocation *point1 = self.path[i];
            CLLocation *point2 = self.path[i+1];

            CLLocationDistance drift = [location dr_perpendicularDistanceWithLocation:point1 location:point2];
            if (drift<minDrift) {
                minDrift = drift;
                leg = i;
            }
        }
        DRDriftResult *result = [DRDriftResult new];
        result.drift = minDrift;
        result.location = location;
        result.leg = leg;

        //Calculate left right by rotating
        //Mercator projection of points
        //Find checkpoint that is moved to: Keep history of drifts
        //OR course of location, better because no history
        //Rotate so that checkpoint leg is pointing north
        //http://en.wikipedia.org/wiki/Rotation_matrix
        //see if location.x is <(left) or >(right) than checkpoint.x
        
        return result;
    }
}

-(void)locationManager:(DRLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(dataProcessor:didFailWithError:)]) {
        [self.delegate dataProcessor:self didFailWithError:error];
    }
}

@end
