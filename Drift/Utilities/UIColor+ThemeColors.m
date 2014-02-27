//
//  UIColor+ThemeColors.m
//  Drift
//
//  Created by Christoph Albert on 2/27/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "UIColor+ThemeColors.h"

@implementation UIColor (ThemeColors)

+(UIColor *)backgroundColor {
    return [UIColor colorWithWhite:1 alpha:1];
}

+(UIColor *)primaryColor {
    return [UIColor colorWithWhite:0.3 alpha:1];
}

+(UIColor *)secondaryColor {
    return [UIColor colorWithWhite:0.6 alpha:1];
}

@end
