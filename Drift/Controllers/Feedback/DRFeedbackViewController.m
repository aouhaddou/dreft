//
//  DRVisualFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRFeedbackViewController.h"
#import "DRDataProcessor.h"
#import "SIAlertView.h"
#import "DRGPSStrengthView.h"

@interface DRFeedbackViewController ()

@property (nonatomic, strong) DRRun *run;
@property (nonatomic, strong) DRGPSStrengthView *gpsStrength;

@end

@implementation DRFeedbackViewController
@synthesize processor = _processor;

-(id)initWithDataProcessor:(DRDataProcessor *)processor
{
    self = [super initWithNibName:@"DRFeedbackViewController" bundle:nil];
    if (self) {
        _processor = processor;
        _processor.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [DRTheme backgroundColor];
    self.driftLabel.textColor = [DRTheme base4];
    self.driftLabel.backgroundColor = self.view.backgroundColor;
    self.driftLabel.text = NSLocalizedString(@"–", nil);

    self.navigationBar.showsShadow = NO;
    self.navigationBar.topItem.title = [NSLocalizedString(@"Run", nil) uppercaseString];

    self.bottomButton = [BRButton buttonWithColor:[DRTheme base4] titleColor:[DRTheme base1]];
    self.bottomButton.frame = CGRectMake(kSideMargin, self.view.height-kSideMargin-44.f, self.view.width-2*kSideMargin, 44.f);
    [self.bottomButton setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
    [self.bottomButton addTarget:self action:@selector(stopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.bottomButton];

    DRGPSStrengthView *gps = [[DRGPSStrengthView alloc] init];
    gps.y = self.navigationBar.height-7-gps.height;
    gps.x = self.navigationBar.width-10-gps.width;
    [self.navigationBar addSubview:gps];
    self.gpsStrength = gps;
}

-(void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}

-(void)start {
    [_processor start];
}

-(void)stopButtonPressed:(id)sender {
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"Do you really want to finish your run?", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"Finish", nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        [_processor stop];
    }];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDriftResult *)result {
    self.driftLabel.text = [NSString stringWithFormat:@"%.1f m",result.drift];
    [self.gpsStrength updateSignalStrengthWithLocation:result.location];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    self.driftLabel.text = NSLocalizedString(@"–", nil);
}

@end
