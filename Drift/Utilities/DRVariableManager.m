//
//  DRVariableManager.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRVariableManager.h"

@implementation DRVariableManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        self.baseRateForAcousticFeedback = 20;
        self.GPSOneBarThresh = 50;
        self.GPSTwoBarThresh = 15;
        self.GPSThreeBarThresh = 6;
    }
    return self;
}

@end