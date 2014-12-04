//
//  AppDelegate.m
//  AudioVK
//
//  Created by Roman Gardukevich on 27.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AppDelegate.h"
#import "VKDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application initializeServicesWithOptions:launchOptions];

    return YES;
}

- (void)application:(UIApplication *)application initializeServicesWithOptions:(NSDictionary*)launchOptions{
    [VKSdk initializeWithDelegate:[VKDelegate sharedDelegate] andAppId:@"4657523"];
    [Parse setApplicationId:@"7Ky1DZqyCKlzex4hgiCsFj2Lg1CHVAKtf5GLhBF8"
                  clientKey:@"QE4JrBZPVhvPgtjbKnCHdLswZcgYSRKH8MtYTk4X"];
    [PFTwitterUtils initializeWithConsumerKey:@"mU6FRz89p9NOwIoPtQkWN0Ujb" consumerSecret:@"tq5Hcz6fu17vRiv8f1Idt9L2JkBi85XhF3Nantx1B4ufhrEwxD"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
