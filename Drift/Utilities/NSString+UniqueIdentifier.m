//
//  NSString+UniqueIdentifier.m
//  Datalove
//
//  Created by Christoph on 3/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "NSString+UniqueIdentifier.h"

@implementation NSString (UniqueIdentifier)

+(NSString *)uniqueIdentifier {
    return [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

@end
