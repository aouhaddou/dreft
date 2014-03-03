//
//  DRVisualFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRVisualFeedbackViewController.h"
#import "DRDataProcessor.h"

@interface DRVisualFeedbackViewController ()

@property (nonatomic, strong) DRRun *run;

@end

@implementation DRVisualFeedbackViewController
@synthesize processor = _processor;

-(id)initWithDataProcessor:(DRDataProcessor *)processor
{
    self = [super initWithNibName:@"DRVisualFeedbackViewController" bundle:nil];
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
    self.view.backgroundColor = [UIColor dr_backgroundColor];
    self.driftLabel.textColor = [UIColor dr_base1];
    self.driftLabel.backgroundColor = self.view.backgroundColor;
    self.driftLabel.text = NSLocalizedString(@"–", nil);
}

-(void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}

-(void)start {
    [_processor start];
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
