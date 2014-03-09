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

typedef NS_ENUM(NSInteger, DRFeedbackType) {
    DRFeedbackTypeQuantitative = 0,
    DRFeedbackTypeQualitative = 1
};

typedef NS_ENUM(NSInteger, DRFeedbackModality) {
    DRFeedbackModalityVisual = 0,
    DRFeedbackModalityAudio = 1
};

@interface DRFeedbackViewController : UIViewController <DRFeedbackModule>

@property (strong, nonatomic) IBOutlet DRNavigationBar *navigationBar;
@property (strong, nonatomic) BRButton *bottomButton;
@property (strong, nonatomic) NSString *pathID;
@property (nonatomic, assign) DRFeedbackType feedbackType;

-(void)start;
-(void)cancelRun;
-(void)stopRun;

@end
