//
//  DRDistanceFormatter.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface DRDistanceFormatter : NSObject

@property (nonatomic, assign) BOOL abbreviate;
@property (nonatomic, assign) NSInteger maximumFractionDigits;

-(NSString *)stringFromDistance:(CLLocationDistance)distance;

@end
