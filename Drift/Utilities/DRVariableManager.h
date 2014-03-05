//
//  DRVariableManager.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRVariableManager : NSObject

@property (nonatomic, strong) NSNumber *baseRateForAcousticFeedback;

@property (nonatomic, strong) NSNumber *GPSOneBarThresh;
@property (nonatomic, strong) NSNumber *GPSTwoBarThresh;
@property (nonatomic, strong) NSNumber *GPSThreeBarThresh;

+ (instancetype)sharedManager;

@end
