//
//  UIColor+Brightness.h
//  Datalove
//
//  Created by Christoph on 3/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

- (UIColor *)lightenColorWithValue:(float)value;
- (UIColor *)darkenColorWithValue:(float)value;
- (BOOL) isLightColor;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;

- (UIColor *)colorToColor:(UIColor *)toColor percent:(float)percent;
- (UIImage*)image;

@end
