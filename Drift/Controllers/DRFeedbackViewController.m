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

@interface DRFeedbackViewController ()

@property (nonatomic, strong) DRRun *run;

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
}

-(void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}

-(void)start {
    [_processor start];

    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Damn!" andMessage:@"You started recording some stuff. Nice! Don't go to far off the path…"];
    [alert addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeDestructive handler:nil];
    [alert addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeDefault handler:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDriftResult *)result {
    self.driftLabel.text = [NSString stringWithFormat:@"%.1f m",result.drift];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    self.driftLabel.text = NSLocalizedString(@"–", nil);
}

@end
