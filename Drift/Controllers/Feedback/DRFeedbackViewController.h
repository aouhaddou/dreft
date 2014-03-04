//
//  DRVisualFeedbackViewController.h
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRFeedbackModule.h"
#import "DRModel.h"
#import "BRButton.h"
#import "DRNavigationBar.h"
#import "DRDataProcessor.h"

@import CoreLocation;

@interface DRFeedbackViewController : UIViewController <DRFeedbackModule>

@property (strong, nonatomic) IBOutlet DRNavigationBar *navigationBar;
@property (strong, nonatomic) BRButton *bottomButton;

@end
