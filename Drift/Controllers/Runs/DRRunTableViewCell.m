//
//  DRRunTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRRunTableViewCell.h"
#import "DRPathView.h"

@interface DRRunTableViewCell()

@property (nonatomic, strong) DRPathView *pathView;

@end

@implementation DRRunTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [DRTheme boldFontWithSize:18.f];
        self.textLabel.textColor = [DRTheme base1];
        self.textLabel.backgroundColor = self.panContentView.backgroundColor;

        self.detailTextLabel.font = [DRTheme boldFontWithSize:18.f];
        self.detailTextLabel.textColor = [DRTheme base1];
        self.detailTextLabel.backgroundColor = self.panContentView.backgroundColor;

        DRPathView *pathView = [[DRPathView alloc] init];
        pathView.backgroundColor = self.panContentView.backgroundColor;
        pathView.marksEndOfPrimaryLine = NO;
        pathView.primaryLineColor = [DRTheme base1];
        pathView.secondaryLineColor = [DRTheme base2];
        pathView.lineWidth = 2;
        pathView.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentLeft;
        pathView.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;
        [self.panContentView addSubview:pathView];
        self.pathView = pathView;
    }
    return self;
}

+(CGFloat)height {
    return 79.f;
}

+(CGFloat)driftMargin {
    return kSideMargin;
}

+(CGFloat)lengthMargin {
    return 113.f;
}

+(CGFloat)courseMargin {
    return 210.f;
}

-(void)setRun:(DRRun *)run {
    NSMutableArray *primary = [NSMutableArray array];
    for (DRDrift *drift in run.drifts) {
        if (drift.location) {
            [primary addObject:drift.location];
        }
    }
    self.pathView.primaryLocations = primary;
    if (run.path) {
        self.pathView.secondaryLocations = run.path.locations;
    }
    _runID = run.uniqueID;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGFloat pathMargin = 10;
    self.pathView.width = self.contentView.width-[DRRunTableViewCell courseMargin]-25;
    self.pathView.height = [DRRunTableViewCell height]-2*pathMargin;
    self.pathView.x = [DRRunTableViewCell courseMargin];
    self.pathView.y = pathMargin;

    self.textLabel.x = [DRRunTableViewCell driftMargin];
    self.detailTextLabel.x = [DRRunTableViewCell lengthMargin];

    self.textLabel.width = self.detailTextLabel.left-self.textLabel.left-5;
    self.textLabel.height = [DRRunTableViewCell height]-20;
    self.textLabel.y = ([DRRunTableViewCell height]-self.textLabel.height)/2.f;

    self.detailTextLabel.width = self.pathView.left-self.detailTextLabel.left-5;
    self.detailTextLabel.height = self.textLabel.height;
    self.detailTextLabel.y = self.textLabel.y;
}

@end
