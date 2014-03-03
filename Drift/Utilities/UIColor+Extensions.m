//
//  UIColor+Brightness.m
//  Datalove
//
//  Created by Christoph on 3/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

- (UIColor *)lightenColorWithValue:(float)value {
    size_t   totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;

    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
    CGFloat newComponents[4];

    if (isGreyscale) {
        newComponents[0] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[1] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[2] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[1] = oldComponents[1]+value > 1.0 ? 1.0 : oldComponents[1]+value;
        newComponents[2] = oldComponents[2]+value > 1.0 ? 1.0 : oldComponents[2]+value;
        newComponents[3] = oldComponents[3];
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);

	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);

    return retColor;
}

- (UIColor *)darkenColorWithValue:(float)value {
    size_t   totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;

    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
    CGFloat newComponents[4];

    if (isGreyscale) {
        newComponents[0] = oldComponents[0]-value < 0.0 ? 0.0 : oldComponents[0]-value;
        newComponents[1] = oldComponents[0]-value < 0.0 ? 0.0 : oldComponents[0]-value;
        newComponents[2] = oldComponents[0]-value < 0.0 ? 0.0 : oldComponents[0]-value;
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]-value < 0.0 ? 0.0 : oldComponents[0]-value;
        newComponents[1] = oldComponents[1]-value < 0.0 ? 0.0 : oldComponents[1]-value;
        newComponents[2] = oldComponents[2]-value < 0.0 ? 0.0 : oldComponents[2]-value;
        newComponents[3] = oldComponents[3];
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);

	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);

    return retColor;
}

- (BOOL) isLightColor {
    size_t   totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;

    CGFloat* components = (CGFloat *)CGColorGetComponents(self.CGColor);
    CGFloat sum;

    if (isGreyscale) {
        sum = components[0];
    } else {
        sum = (components[0]+components[1]+components[2])/3.0;
    }

    return (sum > 0.8);
}

- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	size_t numComponents = CGColorGetNumberOfComponents([self CGColor]);
	CGFloat newComponents[4];

	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = newAlpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = newAlpha;
			break;
		}
	}

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);

	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);

	return retColor;
}

- (UIColor *)colorToColor:(UIColor *)toColor percent:(float)percent
{
    float dec = percent / 100.f;
    CGFloat fRed, fBlue, fGreen, fAlpha;
    CGFloat tRed, tBlue, tGreen, tAlpha;
    CGFloat red, green, blue, alpha;

    if(CGColorGetNumberOfComponents(self.CGColor) == 2) {
        [self getWhite:&fRed alpha:&fAlpha];
        fGreen = fRed;
        fBlue = fRed;
    }
    else {
        [self getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
    }
    if(CGColorGetNumberOfComponents(toColor.CGColor) == 2) {
        [toColor getWhite:&tRed alpha:&tAlpha];
        tGreen = tRed;
        tBlue = tRed;
    }
    else {
        [toColor getRed:&tRed green:&tGreen blue:&tBlue alpha:&tAlpha];
    }

    red = (dec * (tRed - fRed)) + fRed;
    green = (dec * (tGreen - fGreen)) + fGreen;
    blue = (dec * (tBlue - fBlue)) + fBlue;
    alpha = (dec * (tAlpha - fAlpha)) + fAlpha;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)image{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
