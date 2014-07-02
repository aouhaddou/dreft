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
#import "UIView+Image.h"
#import "UIColor+Extensions.h"
#import "DRChoosePathViewController.h"
#import "DRDistanceFormatter.h"
#import "DRRunViewController.h"
#import "BRSettingsIcon.h"
#import "SIAlertView.h"
#import "DRFeedbackViewController.h"

static NSString *const kCoursesCellIdentifier = @"CoursesCell";
static NSString *const kRunCellIdentifier = @"RunCell";

static CGFloat const headerHeight = 82.f;

@interface DRRunsViewController ()

@property (nonatomic ,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UIButton *startButton;
@property (nonatomic ,strong) UIButton *settingsButton;
@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;

@end

@implementation DRRunsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fetchedResultsController = [DRRun MR_fetchAllSortedBy:@"created" ascending:NO withPredicate:nil groupBy:nil delegate:self];

        self.distanceFormatter = [[DRDistanceFormatter alloc] init];
        self.distanceFormatter.maximumFractionDigits = 0;
        self.distanceFormatter.abbreviate = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [DRTheme backgroundColor];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

    [self.tableView registerClass:[DRShowPathsTableViewCell class] forCellReuseIdentifier:kCoursesCellIdentifier];
    [self.tableView registerClass:[DRRunTableViewCell class] forCellReuseIdentifier:kRunCellIdentifier];

    [self.view addSubview:self.headerView];
    UIView *placeholder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.width, self.headerView.height-20)];
    placeholder.backgroundColor = self.headerView.backgroundColor;
    self.tableView.tableHeaderView = placeholder;

    [self configureSettingsView];
    [self.view addSubview:self.settingsView];
}

-(void)configureSettingsView {
    self.settingsView.x = 0;
    self.settingsView.y = -(self.view.height-self.tableView.tableHeaderView.height);
    self.settingsView.backgroundColor = [DRTheme backgroundColor];

    self.zone1Label.font = [DRTheme semiboldFontWithSize:16.f];
    self.zone1Label.textColor = [DRTheme base4];

    self.zone2Label.font = [DRTheme semiboldFontWithSize:16.f];
    self.zone2Label.textColor = [DRTheme base4];

    self.zone1Slider.minimumValue = 0;
    self.zone1Slider.maximumValue = 30;
    self.zone1Slider.value = [[DRVariableManager sharedManager] zone1Thresh];
    self.zone1Slider.maximumTrackTintColor = [DRTheme transparentBase4];
    self.zone1Slider.tintColor = [DRTheme base4];
    self.zone1Slider.minimumTrackTintColor = [DRTheme base4];


    self.zone2Slider.minimumValue = 5;
    self.zone2Slider.maximumValue = 120;
    self.zone2Slider.value = [[DRVariableManager sharedManager] audioFeedbackRate];
    self.zone2Slider.maximumTrackTintColor = [DRTheme transparentBase4];
    self.zone2Slider.tintColor = [DRTheme base4];
    self.zone2Slider.minimumTrackTintColor = [DRTheme base4];

    [self updateSliderLabels];

    [self.typeControl setTitle:NSLocalizedString(@"Meters", nil) forSegmentAtIndex:DRFeedbackTypeQuantitative];
    [self.typeControl setTitle:NSLocalizedString(@"Zones", nil) forSegmentAtIndex:DRFeedbackTypeQualitative];
}

-(IBAction)sliderChangedValue:(UISlider *)slider {
    CGFloat val = round(slider.value);
    if (slider == self.zone1Slider) {
        [DRVariableManager sharedManager].zone1Thresh = val;
    } else if (slider == self.zone2Slider) {
        [DRVariableManager sharedManager].audioFeedbackRate = val;
    }
    [self updateSliderLabels];
}

-(void)updateSliderLabels {
    CGFloat thresh = round(self.zone1Slider.value);
    self.zone1Label.text = [NSString stringWithFormat:NSLocalizedString(@"Zone 1: %.0f m | Zone 2: %.0f m", nil),thresh,thresh*2];
    self.zone2Label.text = [NSString stringWithFormat:NSLocalizedString(@"Audio Feedback: %.0f s", nil),round(self.zone2Slider.value)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat yPos = -scrollView.contentOffsetY;
        if (yPos > 0) {
            yPos = 0;
        }
        self.headerView.y = yPos;
    }
}

-(void)settingsButtonTapped:(UIButton *)button {
    button.selected = !button.selected;
    CGFloat trans = self.view.height-self.tableView.tableHeaderView.height-20;
    if (button.selected) {
        self.settingsView.y = -trans+20;
        [self.view bringSubviewToFront:self.settingsView];
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.y = 20+trans;
            self.settingsButton.transform = CGAffineTransformMakeRotation(M_PI-0.0001);
            self.headerView.y = trans;
            self.settingsView.y = 20;
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.y = 20;
            self.settingsButton.transform = CGAffineTransformIdentity;
            self.headerView.y = 0;
            self.settingsView.y = -trans+20;
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:self.headerView];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)headerView {
    if (_headerView == nil) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 240.f)];
        header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        header.backgroundColor = [DRTheme backgroundColor];

        self.startButton.center = header.center;
        self.settingsButton.center = header.center;

        self.startButton.y -= 15;
        self.settingsButton.y += 76;

        [header addSubview:self.settingsButton];
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

-(UIButton *)settingsButton {
    if (_settingsButton == nil) {
        CGFloat width = 44.f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [DRTheme backgroundColor];
        button.frame = CGRectMake(0, 0, width, width);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);


        [button setImage:[BRSettingsIcon imageWithColor:[DRTheme transparentBase4]] forState:UIControlStateNormal];
        [button setImage:[BRSettingsIcon imageWithColor:[DRTheme transparentBase4]] forState:UIControlStateHighlighted|UIControlStateSelected];
        [button setImage:[BRSettingsIcon imageWithColor:[DRTheme base4]] forState:UIControlStateHighlighted];
        [button setImage:[BRSettingsIcon imageWithColor:[DRTheme base4]] forState:UIControlStateSelected];

        [button addTarget:self action:@selector(settingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        _settingsButton = button;
    }
    return _settingsButton;
}

-(void)startButtonTapped:(id)sender {
    DRChoosePathViewController *choose = [[DRChoosePathViewController alloc] init];
    choose.feedbackType = self.typeControl.selectedSegmentIndex;

    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark draggable delegate

-(void)tableViewCellDidSelectDeleteButton:(DRDraggableTableViewCell *)cell {
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"Do you want to permamently delete this run?", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", nil) type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
        double delayInSeconds = 0.31;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            DRRunTableViewCell *runCell = (DRRunTableViewCell *)cell;
            NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
            DRRun *run = [DRRun objectWithID:runCell.runID inContext:context];
            if (run) {
                [context deleteObject:run];
                [context MR_saveToPersistentStoreAndWait];
            }
        });
    }];
    [alert show];
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
    NSString *identifier;
    if (indexPath.section == 0) {
        identifier = kCoursesCellIdentifier;
    } else {
        identifier = kRunCellIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DRShowPathsTableViewCell class]]) {
        DRShowPathsTableViewCell *pathCell = (DRShowPathsTableViewCell *)cell;
        NSInteger count = [DRPath MR_countOfEntities];
        if (count == 0) {
            pathCell.textLabel.text = [NSLocalizedString(@"Add a course", nil) uppercaseString];
        } else if (count == 1) {
            pathCell.textLabel.text = [[NSString stringWithFormat:NSLocalizedString(@"View %li course", nil),count] uppercaseString];
        } else {
            pathCell.textLabel.text = [[NSString stringWithFormat:NSLocalizedString(@"View %li courses", nil),count] uppercaseString];
        }
    } else if ([cell isKindOfClass:[DRRunTableViewCell class]]) {
        DRRunTableViewCell *runCell = (DRRunTableViewCell *)cell;
        runCell.delegate = self;
        DRRun *run = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        runCell.textLabel.text = [self.distanceFormatter stringFromDistance:run.averageDriftValue];
        runCell.detailTextLabel.text = [self.distanceFormatter stringFromDistance:run.distanceValue];
        [runCell setRun:run];
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

        CGFloat courseMargin = [DRRunTableViewCell courseMargin]+4;
        UILabel *course = [[UILabel alloc] initWithFrame:CGRectMake(courseMargin, title.bottom, tableView.width-courseMargin, labelHeight)];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [DRShowPathsTableViewCell height];
    } else {
        return [DRRunTableViewCell height];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DRPathsViewController *paths = [[DRPathsViewController alloc] init];
        [self.navigationController pushViewController:paths animated:YES];
    } else {
        DRRun *run = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        DRRunViewController *runVC = [[DRRunViewController alloc] init];
        [runVC setRun:run];
        [self.navigationController pushViewController:runVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;
    NSIndexPath *indexPathTrans = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    NSIndexPath *newIndexPathTrans = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPathTrans] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathTrans] withRowAnimation:UITableViewRowAnimationLeft];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPathTrans] atIndexPath:indexPathTrans];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPathTrans] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPathTrans] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
