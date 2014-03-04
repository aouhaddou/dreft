//
//  BButton.h
//  BButton Demo
//
//  Created by Mathieu Bolard on 31/07/12.
//  Copyright (c) 2012 Mathieu Bolard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface BRButton : FUIButton

+(BRButton *)buttonWithColor:(UIColor *)color titleColor:(UIColor *)titleColor;
+(BRButton *)buttonWithColor:(UIColor *)color titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize;

@end
