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
@property (nonatomic, strong) UILabel *title1;
@property (nonatomic, strong) UILabel *body1;
@property (nonatomic, strong) UILabel *title2;
@property (nonatomic, strong) UILabel *body2;
@property (nonatomic, strong) UILabel *title3;
@property (nonatomic, strong) UILabel *body3;
@property (nonatomic, strong) UIImageView *logo;
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

    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DriftLogo.png"]];
    [self.view addSubview:imageView];
    self.logo = imageView;

    UILabel *title1 = [self labelWithText:NSLocalizedString(@"Drift", nil) fontSize:26.f];
    [self.scrollView addSubview:title1];
    self.title1 = title1;

    UILabel *body1 = [self labelWithText:NSLocalizedString(@"Receive real-time feedback during your orienteering run. Swipe to learn how to use this app.", nil) fontSize:16.f];
    [self.scrollView addSubview:body1];
    self.body1 = body1;

    UILabel *title2 = [self labelWithText:NSLocalizedString(@"Create a Course", nil) fontSize:26.f];
    [self.scrollView addSubview:title2];
    self.title2 = title2;

    UILabel *body2 = [self labelWithText:NSLocalizedString(@"The app has to know where the controls of the course are. You can import a GPX file with their coordinates or manually enter them.", nil) fontSize:16.f];
    [self.scrollView addSubview:body2];
    self.body2 = body2;

    UILabel *title3 = [self labelWithText:NSLocalizedString(@"Start Running", nil) fontSize:26.f];
    [self.scrollView addSubview:title3];
    self.title3 = title3;

    UILabel *body3 = [self labelWithText:NSLocalizedString(@"Attach the phone to your arm, choose a course and go. You’ll receive feedback about your distance to the course regularly.", nil) fontSize:16.f];
    [self.scrollView addSubview:body3];
    self.body3 = body3;

    self.beginButton = [BRButton buttonWithColor:[DRTheme base4] titleColor:[DRTheme base1]];
    [self.beginButton setTitle:NSLocalizedString(@"Begin", nil) forState:UIControlStateNormal];
    [self.beginButton addTarget:self action:@selector(beginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.beginButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;

    [self.scrollView addSubview:self.beginButton];
}

-(void)viewDidLayoutSubviews {
    CGFloat titleY = self.view.height*0.46;
    CGFloat bodyY = titleY+70;

    self.logo.centerX = self.view.centerX;
    self.logo.y = (self.view.height-self.logo.height)/2;

    self.title1.y = titleY;
    self.title1.x = 0*self.scrollView.width+fabs((self.title1.width-self.scrollView.width))/2;
    self.body1.y = bodyY;
    self.body1.x = 0*self.scrollView.width+fabs((self.body1.width-self.scrollView.width))/2;

    self.title2.y = titleY;
    self.title2.x = 1*self.scrollView.width+fabs((self.title2.width-self.scrollView.width))/2;
    self.body2.y = bodyY;
    self.body2.x = 1*self.scrollView.width+fabs((self.body2.width-self.scrollView.width))/2;

    self.title3.y = titleY;
    self.title3.x = 2*self.scrollView.width+fabs((self.title3.width-self.scrollView.width))/2;
    self.body3.y = bodyY;
    self.body3.x = 2*self.scrollView.width+fabs((self.body3.width-self.scrollView.width))/2;

    CGFloat buttonHeight = 50.f;
    self.beginButton.frame = CGRectMake(kSideMargin+2*self.scrollView.width, self.view.height-kSideMargin-buttonHeight, self.view.width-2*kSideMargin, buttonHeight);

    self.pageControl.y = self.beginButton.centerY-self.pageControl.height/2;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*3, 0);
}

-(void)viewWillAppear:(BOOL)animated {
    self.scrollView.alpha = 0;
    self.pageControl.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 delay:0.7 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        self.scrollView.alpha = 1;
        self.pageControl.alpha = 1;
        self.logo.y = self.view.height*0.2;
    } completion:nil];
}

-(UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 285, 120)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [DRTheme base4];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [DRTheme semiboldFontWithSize:fontSize];
    label.text = text;
    label.numberOfLines = 0;
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
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
