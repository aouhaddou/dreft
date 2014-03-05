//
//  DRVariableManager.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRVariableManager : NSObject

@property (nonatomic, assign) CGFloat baseRateForAcousticFeedback;

@property (nonatomic, assign) CGFloat GPSOneBarThresh;
@property (nonatomic, assign) CGFloat GPSTwoBarThresh;
@property (nonatomic, assign) CGFloat GPSThreeBarThresh;

+ (instancetype)sharedManager;

@end
