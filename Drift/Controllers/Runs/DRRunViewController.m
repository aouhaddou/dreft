//
//  DRRunViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRRunViewController.h"
#import "DRDistanceFormatter.h"
#import "BRBackArrow.h"
#import "NSNumber+Extensions.h"

@interface DRRunViewController ()

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DRRunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(DRDistanceFormatter *)distanceFormatter {
    if (_distanceFormatter == nil) {
        DRDistanceFormatter *formatter = [[DRDistanceFormatter alloc] init];
        formatter.abbreviate = YES;
        formatter.maximumFractionDigits = 1;
        _distanceFormatter = formatter;
    }
    return _distanceFormatter;
}

-(NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter = formatter;
    }
    return _dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [DRTheme backgroundColor];

    self.navigationBar.showsShadow = NO;
    self.navigationBar.topItem.title = [NSLocalizedString(@"Run", nil) uppercaseString];
    self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRBackArrow imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];

    NSArray *valueLabels = @[self.driftLabel,self.distanceLabel,self.timeLabel];
    for (UILabel *label in valueLabels) {
        label.backgroundColor = self.view.backgroundColor;
        label.textColor = [DRTheme base4];
        label.font = [DRTheme semiboldFontWithSize:40.f];
    }

    NSArray *captionLabels = @[self.driftCaption,self.distanceCaption,self.timeCaption];
    for (UILabel *label in captionLabels) {
        label.backgroundColor = self.view.backgroundColor;
        label.textColor = [DRTheme base4];
        label.font = [DRTheme boldFontWithSize:16.f];
    }
    self.driftCaption.text = [NSLocalizedString(@"Average drift", nil) uppercaseString];
    self.distanceCaption.text = [NSLocalizedString(@"Distance", nil) uppercaseString];
    self.timeCaption.text = [NSLocalizedString(@"Time", nil) uppercaseString];

    self.pathView.backgroundColor = self.view.backgroundColor;
    self.pathView.primaryLineColor = [DRTheme base4];
    self.pathView.secondaryLineColor = [DRTheme transparentBase4];
    self.pathView.lineWidth = 3;
    self.pathView.marksEndOfPrimaryLine = NO;
    self.pathView.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentCenter;
    self.pathView.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;

    if ([_runID length] > 0) {
        DRRun *run = [DRRun objectWithID:_runID];
        if (run) {
            [self updateForRun:run];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if ([self.navigationController.viewControllers  count] > 2) {
        //Pop from here to start view after recording a run
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:@[[self.navigationController.viewControllers firstObject],[self.navigationController.viewControllers lastObject]]];
        self.navigationController.viewControllers = navigationArray;
    }
}

-(void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.pathView.height = valueForScreen(120, 140);
    self.pathView.y = self.view.height - kSideMargin - self.pathView.height;

    CGFloat topmargin = valueForScreen(10, 20);
    CGFloat bottommargin = valueForScreen(10, 20);
    CGFloat captionDistance = 56;

    self.driftLabel.y = self.navigationBar.bottom + topmargin;
    self.driftCaption.y = self.driftLabel.y+captionDistance;

    self.timeLabel.y = self.pathView.y-bottommargin-captionDistance-self.timeCaption.height;
    self.timeCaption.y = self.timeLabel.y+captionDistance;

    self.distanceLabel.y = self.driftCaption.bottom + 1 + (self.timeLabel.y-self.driftCaption.bottom-captionDistance-self.distanceCaption.height)/2;
    self.distanceCaption.y = self.distanceLabel.y+captionDistance;
}

-(void)setRun:(DRRun *)run; {
    _runID = run.uniqueID;
    if (self.view) {
        [self updateForRun:run];
    }
}

-(void)updateForRun:(DRRun *)run {
    self.navigationBar.topItem.title = [[self.dateFormatter stringFromDate:run.startDate] uppercaseString];
    NSMutableArray *primary = [NSMutableArray array];
    for (DRDrift *drift in run.drifts) {
        [primary addObject:drift.location];
    }
    self.pathView.primaryLocations = primary;
    if (run.path) {
        self.pathView.secondaryLocations = run.path.locations;
    }

    self.driftLabel.text = [self.distanceFormatter stringFromDistance:run.averageDriftValue];
    self.distanceLabel.text = [self.distanceFormatter stringFromDistance:run.distanceValue];
    CGFloat duration = [run.endDate timeIntervalSince1970]-[run.startDate timeIntervalSince1970];
    self.timeLabel.text = [@(duration) shortTimeIntervalString];
}

@end
