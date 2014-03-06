//
//  DRNewPathViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRNewPathViewController.h"
#import "BRBackArrow.h"
#import "BRCheckmarkIcon.h"
#import "DRGPSParser.h"

@interface DRNewPathViewController ()

@end

@implementation DRNewPathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [DRTheme base3];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationBar.showsShadow = YES;
    self.navigationBar.topItem.title = [NSLocalizedString(@"Add Course", nil) uppercaseString];
    self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRBackArrow imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRCheckmarkIcon imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];

    self.textField.placeholder = [NSLocalizedString(@"Enter Coordinate", nil) uppercaseString];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.textField becomeFirstResponder];
}

-(void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(id)sender {
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark text field delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *candidate = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    return [DRGPSParser validateCharacter:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    CLLocation *loc = [DRGPSParser locationFromString:textField.text];
//    if ([DRGPSParser validateString:textField.text]) {
//        DLog(@"YES");
//    } else {
//        DLog(@"NO");
//    }
    return YES;
}

@end
