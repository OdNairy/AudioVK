//
//  AVKStartPromoViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 03.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKStartPromoViewController.h"
#import "VKDelegate.h"
#import "VKStorage.h"
#import "AUVAuthentificationViewController.h"

#import <LiveFrost.h>

#define PERMISSIONS_ARRAY (@[VK_PER_OFFLINE,VK_PER_AUDIO, VK_PER_EMAIL])

@interface AVKStartPromoViewController ()
@end

@implementation AVKStartPromoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[VKDelegate sharedDelegate] addTarget:self action:@selector(vkAccessTokenHasBeenReceived:) forAccessTokenEvents:(VKAccessTokenEventReceived)];
//    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
//    [self.view insertSubview:toolbar atIndex:1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - IB actions
- (IBAction)vkAuthentificationButtonTapped{
    [VKDelegate sharedDelegate].rootVC = self.navigationController;

    [VKSdk authorize:PERMISSIONS_ARRAY];
}


- (void)showSignUpForm{
    AUVAuthentificationViewController* authentificationVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AUVAuthentificationViewController class])];
    authentificationVC.state = AUVAuthentificationVCStateSignUp;
    authentificationVC.vkAccessToken = [VKSdk getAccessToken];
    [self.navigationController pushViewController:authentificationVC animated:YES];
}

- (void)showDashboard{
    [self performSegueWithIdentifier:@"ShowDashboard" sender:self];
}

#pragma mark - Target Action
- (IBAction)vkAccessTokenHasBeenReceived:(VKAccessToken*)accessToken{
    NSString *const AVKSessionTokenStorageKey = @"AudioVKSessionToken";
    [[[[VKStorage sharedStorage] valueForKey:AVKSessionTokenStorageKey]
      continueWithBlock:^id(BFTask *task) {
          NSString* sessionToken = task.result;
          if (sessionToken.length) {
              return [PFUser becomeInBackground:sessionToken];
          }else {
              // Need sign up
              [self showSignUpForm];
              return nil;
          }
      }]
     continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
         if (task.result && !task.error) {
             [self showDashboard];
         }else if (task.error.code == kPFErrorObjectNotFound){
             [[VKStorage sharedStorage] setNilValueForKey:AVKSessionTokenStorageKey];
             [self showSignUpForm];
         } else {
             return task;
         }
         return nil;
     }];
    return;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDashboard"]) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

@end
