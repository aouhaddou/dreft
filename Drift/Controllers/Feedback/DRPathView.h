//
//  DRPathView.h
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPathView : UIView

@property (nonatomic, strong) NSArray *primaryPoints;
@property (nonatomic, strong) NSArray *secondaryPoints;
@property (nonatomic, assign) BOOL marksEndOfPrimaryLine;

@end
