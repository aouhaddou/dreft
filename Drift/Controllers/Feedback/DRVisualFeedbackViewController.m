//
//  DRVisualFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRVisualFeedbackViewController.h"
#import "DRPathView.h"
#import "NSDate+Utilities.h"
#import "NSArray+DRExtensions.h"
#import "CLLocation+DRExtensions.h"
#import "DRDistanceFormatter.h"
#import "DRDriftView.h"

const BOOL debug = NO;
const BOOL showAngle = NO;

@interface DRVisualFeedbackViewController ()

@property (nonatomic, strong) UILabel *driftLabel;
@property (nonatomic, strong) UILabel *directionLabel;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) DRPathView *pathView;
@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;
@property (nonatomic, strong) DRDriftView *driftView;

@end

@implementation DRVisualFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    UILabel *driftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, self.navigationBar.bottom, self.view.width-2*kSideMargin, 66)];
    driftLabel.textAlignment = NSTextAlignmentCenter;
    driftLabel.textColor = [DRTheme base4];
    driftLabel.backgroundColor = self.view.backgroundColor;
    driftLabel.adjustsFontSizeToFitWidth = YES;
    driftLabel.minimumScaleFactor = 0.25;
    driftLabel.font = [DRTheme semiboldFontWithSize:56.f];
    driftLabel.text = NSLocalizedString(@"–", nil);
    driftLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:driftLabel];
    self.driftLabel = driftLabel;

    UILabel *directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, self.driftLabel.bottom, self.view.width-2*kSideMargin, 44)];
    directionLabel.textAlignment = NSTextAlignmentCenter;
    directionLabel.textColor = [DRTheme base4];
    directionLabel.backgroundColor = self.view.backgroundColor;
    directionLabel.adjustsFontSizeToFitWidth = YES;
    directionLabel.minimumScaleFactor = 0.25;
    directionLabel.font = [DRTheme semiboldFontWithSize:36.f];
    directionLabel.text = nil;
    directionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:directionLabel];
    self.directionLabel = directionLabel;

    CGFloat iphone4width = 210;
    CGFloat viewMargin = valueForScreen((self.view.width-iphone4width)/2, kSideMargin);
    DRDriftView *driftView = [[DRDriftView alloc] initWithFrame:CGRectMake(viewMargin, directionLabel.bottom+kSideMargin, valueForScreen(iphone4width, self.view.width-2*viewMargin), valueForScreen(iphone4width, self.view.width-2*viewMargin))];
    driftView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.driftView = driftView;
    [self.view insertSubview:driftView atIndex:0];

    if (debug) {
        self.driftView.hidden = YES;
        DRPathView *path = [[DRPathView alloc] initWithFrame:CGRectMake(kSideMargin, directionLabel.bottom+kSideMargin, self.view.width-2*kSideMargin, self.view.height - directionLabel.bottom- self.bottomButton.height - 3*kSideMargin)];
        path.backgroundColor = self.view.backgroundColor;
        path.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        path.marksEndOfPrimaryLine = YES;
        path.secondaryLocations = self.processor.locations;
        path.primaryLineColor = [DRTheme base4];
        path.secondaryLineColor = [DRTheme transparentBase4];
        path.lineWidth = 6;
        path.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;
        path.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentCenter;
        self.pathView = path;
        [self.view addSubview:path];
    }

    [self updateTitle];
}

-(DRDistanceFormatter *)distanceFormatter {
    if (_distanceFormatter == nil) {
        DRDistanceFormatter *distance = [[DRDistanceFormatter alloc] init];
        distance.abbreviate = YES;
        _distanceFormatter = distance;
    }
    return _distanceFormatter;
}

-(void)updateTitle {
    if (self.feedbackType == DRFeedbackTypeQualitative) {
        self.navigationBar.topItem.title = [NSLocalizedString(@"You are in", nil) uppercaseString];
    } else {
        self.navigationBar.topItem.title = [NSLocalizedString(@"You are", nil) uppercaseString];
    }
}

-(void)setFeedbackType:(DRFeedbackType)feedbackType {
    [super setFeedbackType:feedbackType];
    [self updateTitle];
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    self.driftLabel.text = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeStringForDrift:result] : [self quantitativeStringForDrift:result];

    NSString *directionString = nil;
    if (result.direction == DRDriftDirectionRight) {
        directionString = [NSLocalizedString(@"right", nil) uppercaseString];
    } else if (result.direction == DRDriftDirectionLeft) {
        directionString = [NSLocalizedString(@"left", nil) uppercaseString];
    }

    self.directionLabel.text = showAngle ? [NSString stringWithFormat:@"%.0f°, %@",result.angle,directionString] : directionString;
    self.driftView.drift = result;

    if (debug) {
        [self addLocationToHistory:result.location];
        self.pathView.primaryLocations = self.locationHistory;
    }
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    self.driftLabel.text = NSLocalizedString(@"–", nil);
}

-(void)addLocationToHistory:(CLLocation *)location {
    if (self.locationHistory == nil) {
        self.locationHistory = [[NSMutableArray alloc] init];
    }
    CLLocation *last = [self.locationHistory lastObject];

    if (last == nil || [last.timestamp isEarlierThanDate:location.timestamp]) {
        [self.locationHistory addObject:location];
    }
}

#pragma mark feedback string

-(NSString *)quantitativeStringForDrift:(DRDrift *)drift {
    NSString *distance = [self.distanceFormatter stringFromDistance:drift.distance];
    return distance;
}

-(NSString *)qualitativeStringForDrift:(DRDrift *)drift {
    if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        return NSLocalizedString(@"Zone 1", nil);
    } else if (drift.distance < [[DRVariableManager sharedManager] zone2Thresh]) {
        return NSLocalizedString(@"Zone 2", nil);
    } else {
        return NSLocalizedString(@"Zone 3", nil);
    }
}



@end
