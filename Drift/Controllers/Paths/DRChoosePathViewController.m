//
//  DRChoosePathViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRChoosePathViewController.h"
#import "DRModel.h"
#import "DRDataProcessor.h"
#import "DRVisualFeedbackViewController.h"
#import "DRAcousticFeedbackViewController.h"

@interface DRChoosePathViewController ()

@end

@implementation DRChoosePathViewController

-(id)init {
    self = [super initWithNibName:@"DRPathsViewController" bundle:nil];
    if (self) {
        self.type = 0;
        self.feedbackModule = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationBar.topItem.title = [NSLocalizedString(@"Choose a Course", nil) uppercaseString];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DRPath *path = [self.fetchedResultsController objectAtIndexPath:indexPath];
    DRDataProcessor *proc = [[DRDataProcessor alloc] initWithLocations:path.locations];
    DRFeedbackViewController *feedbackViewController;
    if (self.feedbackModule == 0) {
        feedbackViewController =  [[DRVisualFeedbackViewController alloc] initWithDataProcessor:proc];
    } else {
        feedbackViewController = [[DRAcousticFeedbackViewController alloc] initWithDataProcessor:proc];
    }
    feedbackViewController.pathID = path.uniqueID;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

-(void)configureCell:(DRPathTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell atIndexPath:indexPath];
    cell.draggable = NO;
}
@end
