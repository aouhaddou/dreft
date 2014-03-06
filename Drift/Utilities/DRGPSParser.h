//
//  DRGPSParser.h
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface DRGPSParser : NSObject

+(BOOL)validateCharacter:(NSString *)input;
+(CLLocation *)locationFromString:(NSString *)input;

@end
