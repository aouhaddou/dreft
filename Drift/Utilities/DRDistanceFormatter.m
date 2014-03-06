//
//  DRDistanceFormatter.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDistanceFormatter.h"

@interface DRDistanceFormatter()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation DRDistanceFormatter

-(id)init {
    self = [super init];
    if (self) {
        self.abbreviate = YES;
        self.maximumFractionDigits = 1;
    }
    return self;
}

-(NSNumberFormatter *)numberFormatter {
    if (_numberFormatter == nil) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        [_numberFormatter setMaximumFractionDigits:self.maximumFractionDigits];
    }
    return _numberFormatter;
}

-(void)setMaximumFractionDigits:(NSInteger)maximumFractionDigits {
    _maximumFractionDigits = maximumFractionDigits;
    self.numberFormatter.maximumFractionDigits = maximumFractionDigits;
}

-(NSString *)stringFromDistance:(CLLocationDistance)distance {
    CGFloat transformed = distance;
    NSString *abbrUnit = @"m";
    NSString *singleUnit = @"meter";
    NSString *unit = @"meters";

    if (distance > 5999) {
        transformed = distance/1000.f;
        abbrUnit = @"km";
        singleUnit = @"kilometer";
        unit = @"kilometers";
    }
    
    NSString *number = [self.numberFormatter stringFromNumber:@(transformed)];
    if (self.abbreviate) {
        return [NSString stringWithFormat:@"%@ %@",number,abbrUnit];
    } else {
        if (distance == 1) {
            return [NSString stringWithFormat:@"%@ %@",number,singleUnit];
        } else {
            return [NSString stringWithFormat:@"%@ %@",number,unit];
        }
    }
}

@end
