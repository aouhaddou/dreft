//
//  DRTutorialViewController.h
//  Drift
//
//  Created by Christoph Albert on 7/2/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRTutorialViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
