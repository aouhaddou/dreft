//
//  DRChoosePathViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRPathsViewController.h"
#import "DRFeedbackViewController.h"

@interface DRChoosePathViewController : DRPathsViewController

@property (nonatomic, assign) DRFeedbackModality feedbackModality;
@property (nonatomic, assign) DRFeedbackType feedbackType;

@end
