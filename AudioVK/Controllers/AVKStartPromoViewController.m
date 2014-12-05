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

#define PERMISSIONS_ARRAY (@[VK_PER_OFFLINE,VK_PER_AUDIO, VK_PER_EMAIL])

@interface AVKStartPromoViewController ()
@end

@implementation AVKStartPromoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeVideoPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseVideoPlaying)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [self.backgroundView playVideoByPath:[[NSBundle mainBundle] pathForResource:@"moments" ofType:@"mp4"] inLoop:YES];
    [[VKDelegate sharedDelegate] addTarget:self action:@selector(vkAccessTokenHasBeenReceived:) forAccessTokenEvents:(VKAccessTokenEventReceived)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self resumeVideoPlaying];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pauseVideoPlaying];
}

- (void)resumeVideoPlaying {
    [self.backgroundView play];
}

- (void)pauseVideoPlaying {
    [self.backgroundView pause];
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
     continueWithBlock:^id(BFTask *task) {
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
