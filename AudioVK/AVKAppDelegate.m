//
//  AVKAppDelegate.m
//  AudioVK
//
//  Created by Roman Gardukevich on 27.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKAppDelegate.h"
#import <VKSdk.h>
#import "AVKDelegate.h"
#import <Parse/Parse.h>
#import <BFTask.h>

@interface AVKAppDelegate ()
@end

@implementation AVKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application initializeServicesWithOptions:launchOptions];
//    [PFUser logInWithUsernameInBackground:@"OdNairy" password:@"sdfljikw" block:^(PFUser *user, NSError *error) {
//        [self runTestCode];
//        
//    }];
    return YES;
}

- (void)runTestCode{
    PFQuery* adminQ = [PFRole query];
    [adminQ whereKey:@"name" equalTo:@"admins"];

    PFQuery* odnairyUser = [PFUser query];
    [odnairyUser whereKey:@"username" equalTo:@"OdNairy"];
    
}

- (void)application:(UIApplication *)application initializeServicesWithOptions:(NSDictionary*)launchOptions{
    [VKSdk initializeWithDelegate:[AVKDelegate sharedDelegate] andAppId:@"4657523"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Parse enableLocalDatastore];

        [Parse setApplicationId:@"7Ky1DZqyCKlzex4hgiCsFj2Lg1CHVAKtf5GLhBF8"
                      clientKey:@"QE4JrBZPVhvPgtjbKnCHdLswZcgYSRKH8MtYTk4X"];
        [PFTwitterUtils initializeWithConsumerKey:@"mU6FRz89p9NOwIoPtQkWN0Ujb" consumerSecret:@"tq5Hcz6fu17vRiv8f1Idt9L2JkBi85XhF3Nantx1B4ufhrEwxD"];
        [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    });
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
