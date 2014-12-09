//
//  AUVAuthentificationRootViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 07.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthentificationRootViewController.h"

#import "AVKStartPromoViewController.h"
#import "AUVAuthentificationViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "VKDelegate.h"
#import "VKStorage.h"

@interface AUVAuthentificationRootViewController ()
@property (nonatomic, strong) MPMoviePlayerController* player;
@property (nonatomic, weak) IBOutlet UIView* contentView;

@property (nonatomic, strong) AVKStartPromoViewController* startViewController;
@property (nonatomic, strong) AUVAuthentificationViewController* authentificationVC;
@end

@implementation AUVAuthentificationRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundVideo];

    [self displayStartViewController];
    
    [[VKDelegate sharedDelegate] addTarget:self
                                    action:@selector(vkAccessTokenHasBeenReceived:)
                      forAccessTokenEvents:(VKAccessTokenEventReceived)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restartVideoPlayer)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma  mark - Notifications Actions
- (void)restartVideoPlayer{
    [self.player play];
}

#pragma mark - Child View Controllers

- (void)displayStartViewController{
    self.startViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AVKStartPromoViewController"];
    self.startViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.startViewController.view];
    [self.startViewController didMoveToParentViewController:self];
    [self addChildViewController:self.startViewController];
}

- (void)displayAuthentificationViewController{
    self.authentificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AUVAuthentificationViewController"];
    [self addChildViewController:_authentificationVC];
    
    [self transitionFromViewController:self.startViewController toViewController:self.authentificationVC];
}

- (void)displaySignUpViewController{
    [self displayAuthentificationViewController];
    self.authentificationVC.state = AUVAuthentificationVCStateSignUp;
    self.authentificationVC.vkAccessToken = [VKSdk getAccessToken];
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController{
    UIView* fromView = fromViewController.view;
    UIView* toView = toViewController.view;
    
    toView.frame = CGRectOffset(fromView.frame, CGRectGetWidth(fromView.frame), 0);
    [self.contentView addSubview:toView];
    
    [UIView animateWithDuration:.3
                     animations:^{
                         toView.frame = self.contentView.bounds;
                         [fromView removeFromSuperview];
                         [fromViewController removeFromParentViewController];
                     } completion:^(BOOL finished) {
                         [toViewController didMoveToParentViewController:self];
                     }];
}
- (void)presentDashboardViewController{
    
}

#pragma mark - Authentification Root Protocol Implementation
- (void)signInAction{
    [self displayAuthentificationViewController];
}

- (void)signInByVKAction{
    [VKDelegate sharedDelegate].rootVC = self.navigationController;
    [VKSdk authorize:@[VK_PER_EMAIL, VK_PER_OFFLINE, VK_PER_AUDIO]];
}


#pragma mark - VK AccessToken

- (void)vkAccessTokenHasBeenReceived:(VKAccessToken*)accessToken{
    
    [[[[VKStorage sharedStorage] valueForKey:AVKSessionTokenStorageKey]
      continueWithBlock:^id(BFTask *task) {
          NSString* sessionToken = task.result;
          if (sessionToken.length) {
              return [PFUser becomeInBackground:sessionToken];
          }else {
              // Need sign up
              [self displaySignUpViewController];
              return nil;
          }
      }]
     continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
         if (task.result && !task.error) {
             [self presentDashboardViewController];
         }else if (task.error.code == kPFErrorObjectNotFound){
             [[VKStorage sharedStorage] setNilValueForKey:AVKSessionTokenStorageKey];
             [self displaySignUpViewController];
         } else {
             return task;
         }
         return nil;
     }];
    return;
}

#pragma mark - Setups
- (void)setupBackgroundVideo{
    self.player = [self playerControllerForBackgroundVideo];
    [self.view addSubview:self.player.view];
    [self.player play];
    [self setupNotBlockableVideoPlaying];
    [self.player.view addMotionEffect:[self motionEffectGroupForBackgroundVideo]];
}

- (void)setupNotBlockableVideoPlaying{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:NULL];
}

#pragma mark - Configurablers
- (MPMoviePlayerController*)playerControllerForBackgroundVideo{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"5" ofType:@"mp4"];
    
    MPMoviePlayerController* player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
    player.controlStyle = MPMovieControlStyleNone;
    player.repeatMode = MPMovieRepeatModeOne;
    player.view.frame = CGRectInset(self.view.bounds, -50, -50);
    player.scalingMode = MPMovieScalingModeAspectFill;
    return player;
}

- (UIMotionEffectGroup*)motionEffectGroupForBackgroundVideo{
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(-50);
    verticalMotionEffect.maximumRelativeValue = @(50);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    horizontalMotionEffect.minimumRelativeValue = @(-50);
    horizontalMotionEffect.maximumRelativeValue = @(50);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    return group;
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
