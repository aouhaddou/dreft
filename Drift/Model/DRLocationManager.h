//
//  BRLocationController.h
//  Datalove
//
//  Created by Christoph on 4/3/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DRLocationManager;
@protocol DRLocationManagerDelegate <NSObject>

-(void)locationManager:(DRLocationManager *)manager didReceiveLocation:(CLLocation *)location;

@optional
- (void)locationManager:(DRLocationManager *)manager didFailWithError:(NSError *)error;

@end

@interface DRLocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

-(void)addDelegate:(id<DRLocationManagerDelegate>)delegate;
-(void)removeDelegate:(id<DRLocationManagerDelegate>)delegate;

@end
