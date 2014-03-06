//
//  DRPathsViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathsViewController.h"
#import "DRModel.h"
#import "DRPathTableViewCell.h"
#import "BRBackArrow.h"
#import "BRAddIcon.h"
#import "DRNewPathViewController.h"

@import CoreLocation;

static NSString *const kPathCellIdentifier = @"kPathCell";

@interface DRPathsViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DRPathsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fetchedResultsController = [DRPath MR_fetchAllSortedBy:@"created" ascending:NO withPredicate:nil groupBy:nil delegate:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationBar.showsShadow = NO;
    self.navigationBar.topItem.title = [NSLocalizedString(@"Courses", nil) uppercaseString];
    self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRBackArrow imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRAddIcon imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];

    [self.tableView registerClass:[DRPathTableViewCell class] forCellReuseIdentifier:kPathCellIdentifier];
}

-(void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(id)sender {
    DRNewPathViewController *new = [[DRNewPathViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.fetchedObjects count]+3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DRPathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPathCellIdentifier forIndexPath:indexPath];
//    cell.path = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CLLocation *applehq = [[CLLocation alloc] initWithLatitude:37.3303991 longitude:-122.0323301];
    CLLocation *appleschool = [[CLLocation alloc] initWithLatitude:37.3287548 longitude:-122.0278099];
    CLLocation *appletree = [[CLLocation alloc] initWithLatitude:37.332519 longitude:-122.026464];
    cell.path = @[applehq,appleschool,appletree];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DRPathTableViewCell height];
}

@end
