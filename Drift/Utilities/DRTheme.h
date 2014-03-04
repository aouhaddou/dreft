//
//  DRTheme.h
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRTheme : NSObject

+(void)apply;
+(UIFont *)fontWithSize:(CGFloat)size;

+(UIColor *)backgroundColor;

+(UIColor *)base4;
+(UIColor *)transparentBase4;
+(UIColor *)base3;
+(UIColor *)base2;
+(UIColor *)base1;
+(UIColor *)base0;

+(UIColor *)dangerColor;
+(UIColor *)confirmColor;

@end
