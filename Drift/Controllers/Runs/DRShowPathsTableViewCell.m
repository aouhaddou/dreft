//
//  DRCoursesTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRShowPathsTableViewCell.h"

@implementation DRShowPathsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [DRTheme boldFontWithSize:14.f];
        self.textLabel.textColor = [DRTheme backgroundColor];
        self.textLabel.backgroundColor = self.contentView.backgroundColor;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.x = kSideMargin;
}

@end
