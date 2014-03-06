//
//  DRGPSParser.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRGPSParser.h"


@implementation DRGPSParser

+(BOOL)validateCharacter:(NSString *)input {
    if ([input length] == 0) {
        return YES;
    }
    return YES;
    NSString *characterPattern = @"^[\\d\\.-\\,\\s]*+\\z";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:characterPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    return match == nil ? NO : YES;
}

+(CLLocation *)locationFromString:(NSString *)input {
    NSArray *parts = [input componentsSeparatedByString:@","];
    if ([parts count] != 2) {
        return nil;
    }

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([parts[0] doubleValue], [parts[1] doubleValue]);
    if (CLLocationCoordinate2DIsValid(coord)) {
        return [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    } else {
        return nil;
    }
}

@end
