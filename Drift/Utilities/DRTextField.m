//
//  DRTextField.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTextField.h"

static CGFloat const margin = 10;
static CGFloat const buttonMargin = 24;

@implementation DRTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    self.backgroundColor = [DRTheme base4];
    self.layer.cornerRadius = 4;
    self.textColor = [DRTheme base1];
    self.font = [DRTheme boldFontWithSize:16.f];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+margin, bounds.origin.y, bounds.size.width-2*margin-buttonMargin, bounds.size.height);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+margin, bounds.origin.y, bounds.size.width-2*margin-buttonMargin, bounds.size.height);
}

@end
