//
//  DDAppDelegate.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/26/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDIAPUse.h"
#import "DDMainParam.h"
#import "iRate.h"
#import <Tapdaq/Tapdaq.h>

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
    [DDIAPUse sharedInstance];
    
    [[Tapdaq sharedSession] setApplicationId:@"54ba536c9c58aa3857e9b0ac"
                                   clientKey:@"2ca7f01b-a6bd-4731-9e29-4d3a53029dc4"];
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].appStoreID = 881531237;
    
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 5;
    
    //enable preview mode
    //    [iRate sharedInstance].previewMode = YES;
}

@end
