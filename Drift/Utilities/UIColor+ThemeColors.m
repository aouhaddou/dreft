//
//  UIColor+ThemeColors.m
//  Drift
//
//  Created by Christoph Albert on 2/27/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "UIColor+ThemeColors.h"
#import "UIColor+Hex.h"

@implementation UIColor (ThemeColors)

+(UIColor *)dr_backgroundColor {
    return [UIColor colorWithRed:40.f/255.f green:175.f/255.f blue:140.f/255.f alpha:1];
}

+(UIColor *)dr_base1 {
    return [UIColor colorWithWhite:1 alpha:1];
}

+(UIColor *)dr_transparentBase1 {
    return [UIColor colorWithWhite:1 alpha:0.5];
}

+(UIColor *)dr_base2 {
    return [UIColor colorWithWhite:0.75 alpha:1];
}

+(UIColor *)dr_base3 {
    return [UIColor colorWithWhite:0.666 alpha:1];
}

+(UIColor *)dr_base4 {
    return [UIColor colorWithWhite:0.333 alpha:1];
}

+(UIColor *)dr_base5 {
    return [UIColor colorWithWhite:0.166 alpha:1];
}

+(UIColor *)dr_dangerColor {
    return [UIColor colorWithHexString:@"e95b4b"];
}

+(UIColor *)dr_confirmColor {
    return [UIColor colorWithHexString:@"2093d2"];
}

@end
