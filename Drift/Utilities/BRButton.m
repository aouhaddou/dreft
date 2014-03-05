//
//  BButton.m
//  BButton Demo
//
//  Created by Mathieu Bolard on 31/07/12.
//  Copyright (c) 2012 Mathieu Bolard. All rights reserved.
//

#import "BRButton.h"
#import "UIColor+Extensions.h"

@implementation BRButton

+(BRButton *)buttonWithColor:(UIColor *)color titleColor:(UIColor *)titleColor {
    return [self buttonWithColor:color titleColor:titleColor fontSize:20.0f];
}

+(BRButton *)buttonWithColor:(UIColor *)color titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize {
    BRButton *button = [[BRButton alloc] init];
    // Initialization code
    button.buttonColor = color;
    button.shadowColor = [color darkenColorWithValue:0.15];
    button.cornerRadius = 0;
    button.shadowHeight = 3;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.shadowColor = [UIColor clearColor];
    button.titleLabel.font = [DRTheme semiboldFontWithSize:fontSize];
    return button;
}


@end
