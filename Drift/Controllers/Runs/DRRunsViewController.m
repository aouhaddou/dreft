//
//  DRRunsViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRRunsViewController.h"
#import "DRModel.h"
#import "DRShowPathsTableViewCell.h"
#import "DRRunTableViewCell.h"
#import "UIView+Image.h"
#import "UIColor+Extensions.h"
#import "DRVisualFeedbackViewController.h"
#import "DRDataProcessor.h"
#import "DRPathsViewController.h"

static NSString *const kCoursesCellIdentifier = @"CoursesCell";
static NSString *const kRunCellIdentifier = @"RunCell";

static CGFloat const headerHeight = 82.f;

@interface DRRunsViewController ()

@property (nonatomic ,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UIButton *startButton;

@end

@implementation DRRunsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fetchedResultsController = [DRRun MR_fetchAllSortedBy:@"created" ascending:NO withPredicate:nil groupBy:nil delegate:nil];
    }
    return self;
}

-(UIView *)headerView {
    if (_headerView == nil) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 240.f)];
        header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        header.backgroundColor = [DRTheme backgroundColor];

        self.startButton.center = header.center;
        self.startButton.y += 3;
        [header addSubview:self.startButton];

        _headerView = header;
    }
    return _headerView;
}

-(UIButton *)startButton {
    if (_startButton == nil) {
        CGFloat width = 96.f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width, width);
        button.tintColor = [DRTheme backgroundColor];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

        UIView *circleOutline = [[UIView alloc] initWithFrame:button.bounds];
        circleOutline.layer.cornerRadius = width/2;
        circleOutline.layer.masksToBounds = YES;
        circleOutline.backgroundColor = [DRTheme base4];
        [button setBackgroundImage:[circleOutline layerRepresentation] forState:UIControlStateNormal];
        circleOutline.backgroundColor = [[DRTheme base4] darkenColorWithValue:0.1f];
        [button setBackgroundImage:[circleOutline layerRepresentation] forState:UIControlStateHighlighted];

        [button setImage:[[UIImage imageNamed:@"Play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:@"Play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];

        [button addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        _startButton = button;
    }
    return _startButton;
}

-(void)startButtonTapped:(id)sender {
    CLLocation *lappisleft = [[CLLocation alloc] initWithLatitude:59.369667 longitude:18.057811];
    CLLocation *lappisright = [[CLLocation alloc] initWithLatitude:59.368551 longitude:18.064678];

    CLLocation *applehq = [[CLLocation alloc] initWithLatitude:37.3303991 longitude:-122.0323301];
    CLLocation *appleschool = [[CLLocation alloc] initWithLatitude:37.3287548 longitude:-122.0278099];
    CLLocation *appletree = [[CLLocation alloc] initWithLatitude:37.332519 longitude:-122.026464];

    DRDataProcessor *proc = [[DRDataProcessor alloc] initWithPath:@[lappisleft,lappisright]];
    DRDataProcessor *proc2 = [[DRDataProcessor alloc] initWithPath:@[applehq,appleschool,appletree]];

    DRVisualFeedbackViewController *visual = [[DRVisualFeedbackViewController alloc] initWithDataProcessor:proc2];

    [self.navigationController pushViewController:visual animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerClass:[DRShowPathsTableViewCell class] forCellReuseIdentifier:kCoursesCellIdentifier];
    [self.tableView registerClass:[DRRunTableViewCell class] forCellReuseIdentifier:kRunCellIdentifier];

    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.fetchedResultsController.fetchedObjects count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DRShowPathsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoursesCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSLocalizedString(@"Add a course", nil) uppercaseString];
        return cell;
    } else {
        DRRunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRunCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"4 km"];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        CGFloat titleHeight = [DRShowPathsTableViewCell height];
        CGFloat labelHeight = 24;
        CGFloat sepHeight = 3;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, headerHeight)];
        view.backgroundColor = [DRTheme base4];

        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, sepHeight)];
        sep.backgroundColor = [DRTheme base3];
        [view addSubview:sep];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake([DRRunTableViewCell driftMargin], sep.height, view.width-[DRRunTableViewCell driftMargin], titleHeight)];
        title.backgroundColor = [DRTheme base4];
        title.font = [DRTheme boldFontWithSize:14.f];
        title.textColor = [DRTheme backgroundColor];
        [view addSubview:title];
        title.text = [NSLocalizedString(@"Past Runs", nil) uppercaseString];

        UILabel *drift = [[UILabel alloc] initWithFrame:CGRectMake([DRRunTableViewCell driftMargin], title.bottom, [DRRunTableViewCell lengthMargin]-[DRRunTableViewCell driftMargin], labelHeight)];
        drift.backgroundColor = [DRTheme base4];
        drift.font = [DRTheme boldFontWithSize:14.f];
        drift.textColor = [DRTheme base2];
        [view addSubview:drift];
        drift.text = [NSLocalizedString(@"Drift", nil) uppercaseString];

        UILabel *length = [[UILabel alloc] initWithFrame:CGRectMake([DRRunTableViewCell lengthMargin], title.bottom, [DRRunTableViewCell courseMargin]-[DRRunTableViewCell lengthMargin], labelHeight)];
        length.backgroundColor = [DRTheme base4];
        length.font = [DRTheme boldFontWithSize:14.f];
        length.textColor = [DRTheme base2];
        [view addSubview:length];
        length.text = [NSLocalizedString(@"Length", nil) uppercaseString];

        UILabel *course = [[UILabel alloc] initWithFrame:CGRectMake([DRRunTableViewCell courseMargin], title.bottom, tableView.width-[DRRunTableViewCell courseMargin], labelHeight)];
        course.backgroundColor = [DRTheme base4];
        course.font = [DRTheme boldFontWithSize:14.f];
        course.textColor = [DRTheme base2];
        [view addSubview:course];
        course.text = [NSLocalizedString(@"Course", nil) uppercaseString];

        UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(tableView.separatorInset.left, view.height-0.5f, view.width-tableView.separatorInset.left, 0.5f)];
        sep2.backgroundColor = tableView.separatorColor;
        [view addSubview:sep2];

        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return headerHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DRPathsViewController *paths = [[DRPathsViewController alloc] init];
        [self.navigationController pushViewController:paths animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
