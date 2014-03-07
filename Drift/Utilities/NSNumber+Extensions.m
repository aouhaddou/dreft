//
//  NSNumber+Extensions.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "NSNumber+Extensions.h"

@implementation NSNumber (Extensions)

- (NSString *)shortTimeIntervalString {
    return [self timeIntervalStringWithWords:NO linebreaks:YES];
}

- (NSString *)timeIntervalString {
    return [self timeIntervalStringWithWords:YES linebreaks:YES];
}

- (NSString *)timeIntervalStringWithWords:(BOOL)words linebreaks:(BOOL)linebreaks {
    // The time interval
    NSTimeInterval theTimeInterval = [self floatValue];

    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];

    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];

    // Get conversion to months, days, hours, minutes
    if (theTimeInterval < 60) {
        unsigned int unitFlags = NSSecondCalendarUnit;

        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
        return [NSString stringWithFormat:@"%ld s",(long)[conversionInfo second]];
    } else if (theTimeInterval < 60*60) {
        unsigned int unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit;

        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
        return [NSString stringWithFormat:@"%ld:%02ld min",(long)[conversionInfo minute],(long)[conversionInfo second]];
    } else if (theTimeInterval < 60*60*24 || words == NO) {
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;

        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
        return [NSString stringWithFormat:@"%ld:%02ld h",(long)[conversionInfo hour],(long)[conversionInfo minute]];
    } else {
        unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;

        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];

        NSString *dayString = nil;
        if ([conversionInfo day] == 1) {
            dayString = [NSString stringWithFormat:NSLocalizedString(@"%d day", nil),[conversionInfo day]];
        } else {
            dayString = [NSString stringWithFormat:NSLocalizedString(@"%d days", nil),[conversionInfo day]];
        }

        NSString *monthString = nil;
        if ([conversionInfo month] == 1) {
            monthString = [NSString stringWithFormat:NSLocalizedString(@"%d month", nil),[conversionInfo month]];
        } else if ([conversionInfo month] > 1) {
            monthString = [NSString stringWithFormat:NSLocalizedString(@"%d months", nil),[conversionInfo month]];
        }

        NSString *yearString = nil;
        if ([conversionInfo year] == 1) {
            yearString = [NSString stringWithFormat:NSLocalizedString(@"%d year", nil),[conversionInfo year]];
        } else if ([conversionInfo year] > 1) {
            yearString = [NSString stringWithFormat:NSLocalizedString(@"%d years", nil),[conversionInfo year]];
        }

        NSMutableString *result = [NSMutableString string];
        NSString *mod = linebreaks ? @"\n" : @", ";
        if (yearString) {
            [result appendString:yearString];
        }
        if (monthString) {
            if (yearString) {
                [result appendString:mod];
            }
            [result appendString:monthString];
        }
        if (dayString) {
            if (yearString || monthString) {
                [result appendString:mod];
            }
            [result appendString:dayString];
        }
        
        return result;
    }
}

@end
