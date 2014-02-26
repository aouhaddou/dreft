//
//  DRVisualFeedbackViewController.h
//  Drift
//
//  Created by Christoph Albert on 2/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRFeedbackModule.h"

@interface DRVisualFeedbackViewController : UIViewController <DRFeedbackModule>

@property (nonatomic, strong) IBOutlet UILabel *driftLabel;

@end
