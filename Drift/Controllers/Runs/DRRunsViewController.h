//
//  DRRunsViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRRunsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
