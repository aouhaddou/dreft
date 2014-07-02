//
//  DRRunsViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRRunTableViewCell.h"

@interface DRRunsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, DRDraggableTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeControl;
@property (strong, nonatomic) IBOutlet UILabel *zone1Label;
@property (strong, nonatomic) IBOutlet UISlider *zone1Slider;
@property (strong, nonatomic) IBOutlet UILabel *zone2Label;
@property (strong, nonatomic) IBOutlet UISlider *zone2Slider;

-(IBAction)sliderChangedValue:(UISlider *)slider;

@end
