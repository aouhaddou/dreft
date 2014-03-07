//
//  DRCountdownCircle.h
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;

@interface DRCountdownCircle : UIView

@property (nonatomic, assign) CFTimeInterval countdownDuration;
@property (nonatomic, assign) CFTimeInterval windupDuration;

-(void)start;

@end
