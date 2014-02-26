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

@interface DRDataProcessor : NSObject <DRLocationManagerDelegate>

@property (nonatomic, assign) id<DRFeedbackModule>delegate;
@property (nonatomic, strong, readonly) NSArray *path;

-(id)initWithPath:(NSArray *)path;
-(void)start;
-(void)stop;

@end
