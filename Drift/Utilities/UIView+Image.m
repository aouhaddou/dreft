//
//  UIView+Image.m
//  Datalove
//
//  Created by Christoph on 4/10/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "UIView+Image.h"
#import <QuartzCore/CALayer.h>

@implementation UIView (Image)

- (UIImage *)imageRepresentation {
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)layerRepresentation {
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
