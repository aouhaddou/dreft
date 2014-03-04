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

@interface DRVisualFeedbackViewController ()

@property (nonatomic, strong) UILabel *driftLabel;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) DRPathView *pathView;

@end

@implementation DRVisualFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *driftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, 120.f, self.view.width-2*kSideMargin, 100)];
    driftLabel.textAlignment = NSTextAlignmentCenter;
    driftLabel.textColor = [DRTheme base4];
    driftLabel.backgroundColor = self.view.backgroundColor;
    driftLabel.adjustsFontSizeToFitWidth = YES;
    driftLabel.minimumScaleFactor = 0.25;
    driftLabel.font = [DRTheme boldFontWithSize:64.f];
    driftLabel.text = NSLocalizedString(@"–", nil);
    driftLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:driftLabel];
    self.driftLabel = driftLabel;

    DRPathView *path = [[DRPathView alloc] initWithFrame:CGRectMake(kSideMargin, driftLabel.bottom+20, self.view.width-2*kSideMargin, 200.f)];
    path.backgroundColor = self.view.backgroundColor;
    path.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:path];
    path.marksEndOfPrimaryLine = YES;
    path.secondaryPoints = self.processor.path;
    self.pathView = path;
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDriftResult *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    self.driftLabel.text = [NSString stringWithFormat:@"%.1f m",result.drift];
    [self addLocationToHistory:result.location];
    self.pathView.primaryPoints = self.locationHistory;
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

@end
