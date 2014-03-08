//
//  DRTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTableViewCell.h"
#import "UIColor+Extensions.h"
#import "BRDisclosureIcon.h"

@interface DRTableViewCell()

@end

@implementation DRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [DRTheme base4];
        self.contentView.backgroundColor = [DRTheme base4];

        UIView *back = [[UIView alloc] init];
        back.backgroundColor = [self.backgroundColor darkenColorWithValue:0.1f];
        self.selectedBackgroundView = back;

        self.showDisclosureIcon = YES;
    }
    return self;
}

+(CGFloat)height {
    return 44.f;
}

-(void)setShowDisclosureIcon:(BOOL)showDisclosureIcon {
    _showDisclosureIcon = showDisclosureIcon;
    if (showDisclosureIcon) {
        self.disclosure = [BRDisclosureIcon viewWithColor:[DRTheme base3]];
        [self.contentView addSubview:self.disclosure];
    } else {
        [self.disclosure removeFromSuperview];
        self.disclosure = nil;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView bringSubviewToFront:self.disclosure];
    self.disclosure.y = ([[self class] height]-self.disclosure.height)/2;
    self.disclosure.x = self.contentView.width-self.disclosure.width-10;
}

@end
