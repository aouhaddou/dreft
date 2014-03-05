//
//  DRRunTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRRunTableViewCell.h"

@implementation DRRunTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [DRTheme boldFontWithSize:18.f];
        self.textLabel.textColor = [DRTheme base1];
        self.textLabel.backgroundColor = self.contentView.backgroundColor;
    }
    return self;
}

+(CGFloat)height {
    return 76.f;
}

+(CGFloat)driftMargin {
    return kSideMargin;
}

+(CGFloat)lengthMargin {
    return 113.f;
}

+(CGFloat)courseMargin {
    return 206.f;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.x = kSideMargin;
}

@end
