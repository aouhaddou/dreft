//
//  DRTheme.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRTheme.h"
#import "DRNavigationBar.h"

@implementation DRTheme

+(void)apply {
    DRNavigationBar *navigationBar = [DRNavigationBar appearance];
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:[UIColor dr_base1],
                                     NSFontAttributeName:[self fontWithSize:16.0]};
    [navigationBar setTitleTextAttributes:textAttributes];
    navigationBar.barTintColor = [UIColor dr_backgroundColor];
    navigationBar.tintColor = [UIColor dr_base1];

//    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
//    [barButton setBackgroundVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];

    UITableView *tableView = [UITableView appearance];
    tableView.backgroundColor = [UIColor dr_base1];
    tableView.separatorColor = [UIColor dr_base4];
    tableView.separatorInset = UIEdgeInsetsMake(0, kSideMargin, 0, 0);
}

+(UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"GothamHTF-Medium" size:size];
}

@end
