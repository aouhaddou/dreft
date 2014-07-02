//
//  DRVisualFeedbackViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRFeedbackViewController.h"
@import AVFoundation;

@interface DRVisualFeedbackViewController : DRFeedbackViewController <DRFeedbackModule, AVSpeechSynthesizerDelegate>

@end
