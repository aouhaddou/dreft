//
//  DRGPSStrengthView.h
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface DRGPSStrengthView : UIView

-(void)updateSignalStrengthWithLocation:(CLLocation *)location;

@end
