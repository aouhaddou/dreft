//
//  DRFeedbackModule.h
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRDataProcessor;
@class DRDrift;
@protocol DRFeedbackModule <NSObject>

@property (nonatomic, strong, readonly) DRDataProcessor *processor;

-(id)initWithDataProcessor:(DRDataProcessor *)processor;

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result;

@optional
-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error;

@end
