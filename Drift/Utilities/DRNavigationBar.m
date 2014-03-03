//
//  BRNavigationBar.m
//  Datalove
//
//  Created by Christoph on 3/27/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "DRNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extensions.h"

@interface DRNavigationBar()

@end

@implementation DRNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.showsShadow = NO;
    self.translucent = NO;
    
    CGRect frame = self.frame;
    if (frame.origin.y == 0) {
        frame.size = CGSizeMake(frame.size.width, 64);
        self.frame = frame;
    }
}

- (void)drawRect:(CGRect)rect
{
    UIColor *color = self.barTintColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    if (self.showsShadow) {
        CGFloat lineWidth = 1;
        UIColor *linecolor2 = [color darkenColorWithValue:0.2];
        if (UIScreenIsRetina) {
            lineWidth = 0.5;
        }
        CGContextSetFillColorWithColor(context, linecolor2.CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height-lineWidth, rect.size.width, lineWidth));
    }
}

@end
