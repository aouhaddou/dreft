//
//  DRPathsViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathsViewController.h"
#import "DRModel.h"
#import "BRBackArrow.h"
#import "BRAddIcon.h"
#import "DRNewPathViewController.h"
#import "DRDistanceFormatter.h"
#import "SIAlertView.h"

@import CoreLocation;

static NSString *const kPathCellIdentifier = @"kPathCell";

@interface DRPathsViewController ()

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;

@end

@implementation DRPathsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fetchedResultsController = [DRPath MR_fetchAllSortedBy:@"created" ascending:NO withPredicate:nil groupBy:nil delegate:self];

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
    return [self.fetchedResultsController.fetchedObjects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DRPathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPathCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(DRPathTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    DRPath *path = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setPath:path];
    cell.delegate = self;
    cell.lengthLabel.text = [self.distanceFormatter stringFromDistance:path.distanceValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DRPathTableViewCell height];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark draggable delegate

-(void)tableViewCellDidSelectDeleteButton:(DRDraggableTableViewCell *)cell {
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"Do you want to permamently delete this course?", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", nil) type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
        double delayInSeconds = 0.31;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            DRPathTableViewCell *pathCell = (DRPathTableViewCell *)cell;
            NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
            DRPath *run = [DRPath objectWithID:pathCell.pathID inContext:context];
            if (run) {
                [context deleteObject:run];
                [context MR_saveToPersistentStoreAndWait];
            }
        });
    }];
    [alert show];
}

#pragma mark fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:(DRPathTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
