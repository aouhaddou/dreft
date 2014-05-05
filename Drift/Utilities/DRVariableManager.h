//
//  DRVariableManager.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRVariableManager : NSObject

@property (nonatomic, assign) CGFloat GPSOneBarThresh;
@property (nonatomic, assign) CGFloat GPSTwoBarThresh;
@property (nonatomic, assign) CGFloat GPSThreeBarThresh;

@property (nonatomic, assign) CGFloat zone1Thresh;
@property (nonatomic, assign) CGFloat audioFeedbackRate;

@property (nonatomic, assign) CGFloat infoThresh;

+ (instancetype)sharedManager;

@end
