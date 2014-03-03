//
//  DRDataProcessor.h
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRLocationManager.h"
#import "DRFeedbackModule.h"

typedef NS_ENUM(NSInteger, DRDriftResultDirection) {
    DRDriftResultDirectionUnknown,
    DRDriftResultDirectionLeft,
    DRDriftResultDirectionRight
};

@interface DRDriftResult : NSObject

@property (nonatomic, assign, readonly) CGFloat drift;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, assign, readonly) NSInteger leg;
@property (nonatomic, assign, readonly) DRDriftResultDirection direction;

@end

@interface DRDataProcessor : NSObject <DRLocationManagerDelegate>

@property (nonatomic, assign) id<DRFeedbackModule>delegate;
@property (nonatomic, strong, readonly) NSArray *path;

-(id)initWithPath:(NSArray *)path;
-(void)start;
-(void)stop;

@end
