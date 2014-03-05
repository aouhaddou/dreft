//
//  BRLocationController.m
//  Datalove
//
//  Created by Christoph on 4/3/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "DRLocationManager.h"

@interface DRLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableSet *delegates;

@end

@implementation DRLocationManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

-(CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.activityType = CLActivityTypeFitness;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    if (newLocation.timestamp.timeIntervalSinceNow > -20 && newLocation.horizontalAccuracy <= kGPSOneBarThresh) { //not older than 20 seconds and more accurate than 50m
        if (self.delegates != nil && [self.delegates count] > 0) {
            NSSet *delegatesSnapshot = [NSSet setWithSet:self.delegates];
            for (id<DRLocationManagerDelegate> delegate in delegatesSnapshot) {
                if ([delegate respondsToSelector:@selector(locationManager:didReceiveLocation:)]) {
                    [delegate locationManager:self didReceiveLocation:newLocation];
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	DLog(@"Location Manager error: %@", [error description]);
    NSSet *delegatesSnapshot = [NSSet setWithSet:self.delegates];
    for (id<DRLocationManagerDelegate> delegate in delegatesSnapshot) {
        if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:self didFailWithError:error];
        }
    }
}

-(void)addDelegate:(id<DRLocationManagerDelegate>)delegate {
    if (self.delegates == nil) {
        self.delegates = [NSMutableSet new];
    }
    [self.delegates addObject:delegate];
    [self.locationManager startUpdatingLocation];
    DLog(@"Started updating location");
}

-(void)removeDelegate:(id<DRLocationManagerDelegate>)delegate {
    [self.delegates removeObject:delegate];
    
    if (self.delegates == nil || [self.delegates count] <= 0) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
        DLog(@"Stopped updating location");
    }
}

@end
