//
//  DRTutorialViewController.m
//  Drift
//
//  Created by Christoph Albert on 7/2/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTutorialViewController.h"
#import "DRAppDelegate.h"
#import "BRButton.h"

@interface DRTutorialViewController ()

@property (nonatomic, strong) UIButton *beginButton;

@end

@implementation DRTutorialViewController

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
    self.view.backgroundColor = [DRTheme backgroundColor];
    // Do any additional setup after loading the view from its nib.

    NSInteger pages = 3;
    self.pageControl.numberOfPages = pages;
    self.pageControl.currentPage = 0;

//    CGFloat imageY = 220;
    CGFloat titleY = 220;
    CGFloat bodyY = 320;

    UILabel *title1 = [self labelWithText:NSLocalizedString(@"Drift", nil) fontSize:26.f];
    title1.y = titleY;
    title1.x = 0*self.scrollView.width+fabs((title1.width-self.scrollView.width))/2;
    [self.scrollView addSubview:title1];

    UILabel *body1 = [self labelWithText:NSLocalizedString(@"Receive real-time feedback during your orienteering run.", nil) fontSize:16.f];
    body1.y = bodyY;
    body1.x = title1.x;
    [self.scrollView addSubview:body1];

    UILabel *title2 = [self labelWithText:NSLocalizedString(@"Create a Course", nil) fontSize:26.f];
    title2.y = titleY;
    title2.x = 1*self.scrollView.width+fabs((title2.width-self.scrollView.width))/2;
    [self.scrollView addSubview:title2];

    UILabel *body2 = [self labelWithText:NSLocalizedString(@"Manually enter the WGS84 coordinates of the controls or import a GPX file.", nil) fontSize:16.f];
    body2.y = bodyY;
    body2.x = title2.x;
    [self.scrollView addSubview:body2];

    UILabel *title3 = [self labelWithText:NSLocalizedString(@"Start Running", nil) fontSize:26.f];
    title3.y = titleY;
    title3.x = 2*self.scrollView.width+fabs((title3.width-self.scrollView.width))/2;
    [self.scrollView addSubview:title3];

    UILabel *body3 = [self labelWithText:NSLocalizedString(@"Attach the phone to your arm, choose a course and go. You’ll receive feedback about your drift regularly.", nil) fontSize:16.f];
    body3.y = bodyY;
    body3.x = title3.x;
    [self.scrollView addSubview:body3];

    CGFloat buttonHeight = 50.f;
    self.beginButton = [BRButton buttonWithColor:[DRTheme base4] titleColor:[DRTheme base1]];
    self.beginButton.frame = CGRectMake(kSideMargin+(pages-1)*self.scrollView.width, self.view.height-kSideMargin-buttonHeight, self.view.width-2*kSideMargin, buttonHeight);
    [self.beginButton setTitle:NSLocalizedString(@"Begin", nil) forState:UIControlStateNormal];
    [self.beginButton addTarget:self action:@selector(beginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.beginButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;

    self.pageControl.y = self.beginButton.centerY-self.pageControl.height/2;

    [self.scrollView addSubview:self.beginButton];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*pages, 0);
}

-(UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width-2*kSideMargin, 120)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [DRTheme base4];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [DRTheme semiboldFontWithSize:fontSize];
    label.text = text;
    label.numberOfLines = 0;
    return label;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginButtonTapped:(id)sender {
    DRAppDelegate *appDelegate = (DRAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate finishedTutorial];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (scrollView.contentOffsetX+self.scrollView.width/2)/self.scrollView.width;
    self.pageControl.currentPage = page;
}


@end
