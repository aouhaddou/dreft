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

@end

@implementation DRVisualFeedbackViewController
@synthesize path = _path;
@synthesize run = _run;
@synthesize processor = _processor;

- (id)initWithPath:(NSArray *)path
{
    self = [super initWithNibName:@"DRVisualFeedbackViewController" bundle:nil];
    if (self) {
        _path = path;
        _processor = [[DRDataProcessor alloc] initWithPath:path];
        _processor.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(CGFloat)drift ofLocation:(CLLocation *)location {
    self.driftLabel.text = [NSString stringWithFormat:@"%.1f m",drift];
}

@end
