//
//  DRVariableManager.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRVariableManager.h"

static NSString *const kRateKey = @"com.christophalbert.drift.variable.kRateKey";

static NSString *const kGPSOneBarKey = @"com.christophalbert.drift.variable.kGPSOneBarKey";
static NSString *const kGPSTwoBarKey = @"com.christophalbert.drift.variable.kGPSTwoBarKey";
static NSString *const kGPSThreeBarKey = @"com.christophalbert.drift.variable.kGPSThreeBarKey";

@implementation DRVariableManager
@synthesize baseRateForAcousticFeedback = _baseRateForAcousticFeedback;
@synthesize GPSOneBarThresh = _GPSOneBarThresh;
@synthesize GPSTwoBarThresh = _GPSTwoBarThresh;
@synthesize GPSThreeBarThresh = _GPSThreeBarThresh;

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

-(NSNumber *)baseRateForAcousticFeedback {
    if (_baseRateForAcousticFeedback == nil) {
        NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:kRateKey];
        if (n == nil) {
            _baseRateForAcousticFeedback = @(20);
        } else {
            _baseRateForAcousticFeedback = n;
        }
    }
    return _baseRateForAcousticFeedback;
}

-(void)setBaseRateForAcousticFeedback:(NSNumber *)baseRateForAcousticFeedback {
    _baseRateForAcousticFeedback = baseRateForAcousticFeedback;
    [[NSUserDefaults standardUserDefaults] setObject:baseRateForAcousticFeedback forKey:kRateKey];
}

-(NSNumber *)GPSOneBarThresh {
    if (_GPSOneBarThresh == nil) {
        NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:kGPSOneBarKey];
        if (n == nil) {
            _GPSOneBarThresh = @(50);
        } else {
            _GPSOneBarThresh = n;
        }
    }
    return _GPSOneBarThresh;
}

-(void)setGPSOneBarThresh:(NSNumber *)GPSOneBarThresh {
    _GPSOneBarThresh = GPSOneBarThresh;
    [[NSUserDefaults standardUserDefaults] setObject:_GPSOneBarThresh forKey:kGPSOneBarKey];
}

-(NSNumber *)GPSTwoBarThresh {
    if (_GPSTwoBarThresh == nil) {
        NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:kGPSTwoBarKey];
        if (n == nil) {
            _GPSTwoBarThresh = @(15);
        } else {
            _GPSTwoBarThresh = n;
        }
    }
    return _GPSTwoBarThresh;
}

-(void)setGPSTwoBarThresh:(NSNumber *)GPSTwoBarThresh {
    _GPSTwoBarThresh = GPSTwoBarThresh;
    [[NSUserDefaults standardUserDefaults] setObject:GPSTwoBarThresh forKey:kGPSTwoBarKey];
}

-(NSNumber *)GPSThreeBarThresh {
    if (_GPSThreeBarThresh == nil) {
        NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:kGPSThreeBarKey];
        if (n == nil) {
            _GPSThreeBarThresh = @(6);
        } else {
            _GPSThreeBarThresh = n;
        }
    }
    return _GPSThreeBarThresh;
}

-(void)setGPSThreeBarThresh:(NSNumber *)GPSThreeBarThresh {
    _GPSThreeBarThresh = GPSThreeBarThresh;
    [[NSUserDefaults standardUserDefaults] setObject:GPSThreeBarThresh forKey:kGPSThreeBarKey];
}

@end