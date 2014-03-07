//
//  DRToolbar.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRToolbar.h"
#import "UIColor+Extensions.h"

@implementation DRToolbar

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
    self.showsShadow = YES;
    self.translucent = NO;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *color = self.barTintColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    if (self.showsShadow) {
        CGFloat lineWidth = 1;
        UIColor *linecolor = [color lightenColorWithValue:0.2];
        if (UIScreenIsRetina) {
            lineWidth = 0.5;
        }
        CGContextSetFillColorWithColor(context, linecolor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, lineWidth));
    }
}

@end
