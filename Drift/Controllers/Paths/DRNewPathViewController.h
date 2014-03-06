//
//  DRNewPathViewController.h
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"
@import MapKit;

@interface DRNewPathViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet DRNavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
