//
//  DRDrift.h
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

typedef NS_ENUM(NSInteger, DRDriftDirection) {
    DRDriftDirectionUnknown,
    DRDriftDirectionLeft,
    DRDriftDirectionRight
};

@interface DRDrift : NSObject <NSCoding>

@property (nonatomic, assign, readonly) CLLocationDistance distance;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, assign, readonly) NSInteger leg;
@property (nonatomic, assign, readonly) DRDriftDirection direction;

@end
