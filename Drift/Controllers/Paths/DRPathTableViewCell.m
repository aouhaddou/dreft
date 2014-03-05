//
//  DRPathTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathTableViewCell.h"
#import "DRPathView.h"

@interface DRPathTableViewCell()

@property (nonatomic, strong) DRPathView *pathView;
@property (nonatomic, strong) UILabel *lengthLabel;

@end

@implementation DRPathTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [DRTheme semiboldFontWithSize:18.f];
        self.textLabel.textColor = [DRTheme base1];
        self.textLabel.backgroundColor = self.contentView.backgroundColor;

        self.detailTextLabel.font = [DRTheme semiboldFontWithSize:18.f];
        self.detailTextLabel.textColor = [DRTheme base1];
        self.detailTextLabel.backgroundColor = self.contentView.backgroundColor;

        UILabel *length = [[UILabel alloc] init];
        length.font = [DRTheme semiboldFontWithSize:18.f];
        length.textColor = [DRTheme base1];
        length.backgroundColor = self.contentView.backgroundColor;
        [self.contentView addSubview:length];
        self.lengthLabel = length;

        DRPathView *path = [[DRPathView alloc] init];
        path.backgroundColor = self.contentView.backgroundColor;
        path.marksEndOfPrimaryLine = NO;
        path.primaryLineColor = [DRTheme base1];
        path.lineWidth = 3;
        path.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;
        path.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentRight;
        [self.contentView addSubview:path];
        self.pathView = path;
    }
    return self;
}

+(CGFloat)height {
    return 120.f;
}

-(void)setPath:(NSArray *)path {
//    _path = path;
    self.textLabel.text = @"Path";
    self.detailTextLabel.text = @"Path";
    self.lengthLabel.text = @"Path";
    self.pathView.primaryLocations = path;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGFloat topMargin = 15;

    CGFloat pathWidth = 80;
    self.pathView.frame = CGRectMake(self.contentView.width-kSideMargin-pathWidth-14, kSideMargin, pathWidth, [DRPathTableViewCell height]-2*kSideMargin);

    self.textLabel.x = kSideMargin;
    self.textLabel.y = topMargin;
    self.textLabel.width = self.pathView.left-self.textLabel.y;

    self.detailTextLabel.x = kSideMargin;
    self.detailTextLabel.y = self.textLabel.bottom;
    self.detailTextLabel.width = self.textLabel.width;

    self.lengthLabel.height = self.textLabel.height;
    self.lengthLabel.x = kSideMargin;
    self.lengthLabel.y = [DRPathTableViewCell height]-self.lengthLabel.height-topMargin;
    self.lengthLabel.width = self.textLabel.width;
}

@end
