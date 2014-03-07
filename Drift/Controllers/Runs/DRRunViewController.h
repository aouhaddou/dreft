//
//  DRRunViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"
#import "DRPathView.h"
#import "DRModel.h"

@interface DRRunViewController : UIViewController

@property (nonatomic, strong, readonly) NSString *runID;

@property (strong, nonatomic) IBOutlet DRNavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet DRPathView *pathView;

@property (strong, nonatomic) IBOutlet UILabel *driftLabel;
@property (strong, nonatomic) IBOutlet UILabel *driftCaption;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceCaption;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeCaption;

-(void)setRun:(DRRun *)run;

@end
