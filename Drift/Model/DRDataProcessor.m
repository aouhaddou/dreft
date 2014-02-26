//
//  DRDataProcessor.m
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDataProcessor.h"
#import "CLLocation+DRExtensions.h"

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
    if ([self.delegate respondsToSelector:@selector(dataProcessor:didCalculateDrift:ofLocation:)]) {
        CGFloat drift = [self minimumDriftForLocation:location];
        [self.delegate dataProcessor:self didCalculateDrift:drift ofLocation:location];
    }
}

-(CGFloat)minimumDriftForLocation:(CLLocation *)location {
    NSInteger count = [self.path count];
    if (count == 0) {
        // No path, no distance
        return 0;
    } else if (count == 1) {
        //Only a point, distance to point
        CLLocation *point = self.path.firstObject;
        return [location distanceFromLocation:point];
    } else {
        //Check all path legs and return shortest distance
        CGFloat minDrift = CGFLOAT_MAX;

        for (NSInteger i = 1; i<count; i++) {
            CLLocation *point1 = self.path[i-1];
            CLLocation *point2 = self.path[i];

            CGFloat drift = [location dr_perpendicularDistanceWithLocation:point1 location:point2];
            if (drift<minDrift) {
                minDrift = drift;
            }
        }

        return minDrift;
    }
}

@end
