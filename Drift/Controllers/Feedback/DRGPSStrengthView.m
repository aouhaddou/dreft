//
//  DRGPSStrengthView.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRGPSStrengthView.h"
#import "NSDate+Utilities.h"

@interface DRGPSStrengthView ()

@property (nonatomic, strong) CLLocation *location;

@end

@implementation DRGPSStrengthView

-(id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    CGFloat width = 23;
    CGFloat height = 25;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        CGFloat labelHeight = 13;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height-labelHeight, width, labelHeight)];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 1;
        label.backgroundColor = self.backgroundColor;
        label.font = [DRTheme semiboldFontWithSize:11.f];
        label.text = NSLocalizedString(@"GPS", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [DRTheme base4];
        [self addSubview:label];
        [self setNeedsDisplay];
    }
    return self;
}

-(void)updateSignalStrengthWithLocation:(CLLocation *)location {
    if (self.location == nil || [location.timestamp isLaterThanDate:self.location.timestamp]) {
        self.location = location;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    //// Rectangle Drawing
    [[DRTheme base4] setFill];
    [[DRTheme base4] setStroke];

    NSInteger strength = 0;
    if (self.location) {
        if (self.location.horizontalAccuracy <= [[[DRVariableManager sharedManager] GPSThreeBarThresh] floatValue]) {
            strength = 3;
        } else if (self.location.horizontalAccuracy <= [[[DRVariableManager sharedManager] GPSTwoBarThresh] floatValue]) {
            strength = 2;
        } else {
            strength = 1;
        }
    }

    CGFloat lineWidth = 1.f;

    UIBezierPath* rectangle1 = [UIBezierPath bezierPathWithRect: CGRectMake(2+lineWidth/2.f, 8+lineWidth/2.f, 5-lineWidth, 4-lineWidth)];
    rectangle1.lineWidth = lineWidth;
    [rectangle1 stroke];
    if (strength >= 1) {
        [rectangle1 fill];
    }

    UIBezierPath* rectangle2 = [UIBezierPath bezierPathWithRect: CGRectMake(9+lineWidth/2.f, 4+lineWidth/2.f, 5-lineWidth, 8-lineWidth)];
    rectangle2.lineWidth = lineWidth;
    [rectangle2 stroke];
    if (strength >= 2) {
        [rectangle2 fill];
    }

    UIBezierPath* rectangle3 = [UIBezierPath bezierPathWithRect: CGRectMake(16+lineWidth/2.f, lineWidth/2.f, 5-lineWidth, 12-lineWidth)];
    rectangle3.lineWidth = lineWidth;
    [rectangle3 stroke];
    if (strength >= 3) {
        [rectangle3 fill];
    }
}

@end
