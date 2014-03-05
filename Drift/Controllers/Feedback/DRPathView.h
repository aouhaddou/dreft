//
//  DRPathView.h
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+DRExtensions.h"

@interface DRPathView : UIView

@property (nonatomic, strong) NSArray *primaryLocations;
@property (nonatomic, strong) NSArray *secondaryLocations;
@property (nonatomic, assign) BOOL marksEndOfPrimaryLine;
@property (nonatomic, strong) UIColor *primaryLineColor;
@property (nonatomic, strong) UIColor *secondaryLineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) NSArrayRelativePointsHorizontalAlignment horizontalAlignment;
@property (nonatomic, assign) NSArrayRelativePointsVerticalAlignment verticalAlignment;
@end
