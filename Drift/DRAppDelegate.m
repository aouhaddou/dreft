//
//  DRAppDelegate.m
//  Drift
//
//  Created by Christoph Albert on 2/17/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRAppDelegate.h"
#import "DRRunsViewController.h"
#import "DRTutorialViewController.h"
#import "CoreData+MagicalRecord.h"
#import "DRGPXParser.h"

@import CoreLocation;

static NSString *tutorialFinishedFlag = @"com.christophalbert.tutorialFinishedFlag";

@implementation DRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Reset Tutorial
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:tutorialFinishedFlag];[[NSUserDefaults standardUserDefaults] synchronize];

    [MagicalRecord setupAutoMigratingCoreDataStack];

    [DRTheme apply];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:tutorialFinishedFlag] == YES) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[DRRunsViewController alloc] init]];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    } else {
        DRTutorialViewController *tutorial = [[DRTutorialViewController alloc] init];
        self.window.rootViewController = tutorial;
    }


    [self.window makeKeyAndVisible];

//    Import Test Data
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sodertorn" withExtension:@"gpx"];
//    [DRGPXParser parseContentsOfURL:url];

    return YES;
}

- (void)finishedTutorial {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:tutorialFinishedFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[DRRunsViewController alloc] init]];
    nav.navigationBarHidden = YES;

    [UIView transitionFromView:self.window.rootViewController.view toView:nav.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        self.window.rootViewController = nav;
    }];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [DRGPXParser parseContentsOfURL:url];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
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
