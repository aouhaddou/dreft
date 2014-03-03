//
//  DRAppDelegate.m
//  Drift
//
//  Created by Christoph Albert on 2/17/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRAppDelegate.h"
#import "DRVisualFeedbackViewController.h"
#import "DRDataProcessor.h"

@import CoreLocation;

@implementation DRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [MagicalRecord setupAutoMigratingCoreDataStack];

    CLLocation *lappisleft = [[CLLocation alloc] initWithLatitude:59.369667 longitude:18.057811];
    CLLocation *lappisright = [[CLLocation alloc] initWithLatitude:59.368551 longitude:18.064678];
    DRDataProcessor *proc = [[DRDataProcessor alloc] initWithPath:@[lappisleft,lappisright]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];

    DRVisualFeedbackViewController *visual = [[DRVisualFeedbackViewController alloc] initWithDataProcessor:proc];

    self.window.rootViewController = visual;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
