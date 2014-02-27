//
//  DRFeedbackModule.h
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRModel.h"

@import CoreLocation;

@class DRDataProcessor;
@protocol DRFeedbackModule <NSObject>

@property (nonatomic, strong, readonly) DRRun *run;
@property (nonatomic, strong, readonly) DRDataProcessor *processor;

-(id)initWithDataProcessor:(DRDataProcessor *)processor;

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(CGFloat)drift ofLocation:(CLLocation *)location;

@optional
-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error;

@end
