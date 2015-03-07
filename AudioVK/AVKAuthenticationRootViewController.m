//
//  AUVAuthenticationRootViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 07.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKAuthenticationRootViewController.h"

#import "AVKStartPromoViewController.h"
#import "AVKAuthenticationViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "AVKDelegate.h"
#import "AVKStorage.h"
#import <VKSdk.h>

#import <ChameleonFramework/Chameleon.h>

typedef NS_ENUM (NSInteger, AVKDirection) {
    AVKDirectionToLeft,
    AVKDirectionToRight
};

@interface AVKAuthenticationRootViewController ()
@property (nonatomic, strong) MPMoviePlayerController* player;
@property (nonatomic, weak) IBOutlet UIView* contentView;

@property (nonatomic, strong) AVKStartPromoViewController* startViewController;
@property (nonatomic, strong) AVKAuthenticationViewController * authentificationVC;
@end

@implementation AVKAuthenticationRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self setupBackgroundVideo];

    [self displayStartViewController];
    
    [[AVKDelegate sharedDelegate] addTarget:self
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
    self.authentificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AUVAuthenticationViewController"];
    [self transitionFromViewController:self.startViewController toViewController:self.authentificationVC operation:(UINavigationControllerOperationPush)];
}

- (void)displaySignUpViewController{
    [self displayAuthentificationViewController];
    self.authentificationVC.state = AUVAuthenticationVCStateSignUp;
    self.authentificationVC.vkAccessToken = [VKSdk getAccessToken];

}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController operation:(UINavigationControllerOperation)operation{
    [self addChildViewController:toViewController];
    UIView* fromView = fromViewController.view;
    UIView* toView = toViewController.view;
    
    toView.frame = CGRectOffset(fromView.frame, (3-2*operation)*CGRectGetWidth(fromView.frame), 0);
    [self.contentView addSubview:toView];
    
    
    void(^animations)(void) = ^(){
        toView.frame = self.contentView.bounds;
        fromView.frame = CGRectOffset(fromView.frame, (2*operation-3)*CGRectGetWidth(fromView.frame), 0);
        [fromViewController removeFromParentViewController];
    };
    
    void(^completion)(BOOL finished) = ^(BOOL finished){
        [fromView removeFromSuperview];
        [toViewController didMoveToParentViewController:self];
        [self flatify];
    };
    if (operation == UINavigationControllerOperationPop) {
        [UIView animateWithDuration:.3
                         animations:animations completion:completion];
    } else {
        [UIView animateWithDuration:.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:(UIViewAnimationOptionCurveEaseIn) animations:animations completion:completion];        
    }
    
}
- (void)presentHomeViewController{
    UIViewController* dashboardRootVC = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateInitialViewController];

    CATransition *transition = [CATransition animation];
    transition.duration = .3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController pushViewController:dashboardRootVC animated:NO];
}

#pragma mark - Authentification Root Protocol Implementation
- (void)signInAction{
    [self displayAuthentificationViewController];
}

- (void)signInByVKAction{
    [AVKDelegate sharedDelegate].rootVC = self.navigationController;
    [VKSdk authorize:@[VK_PER_EMAIL, VK_PER_OFFLINE, VK_PER_AUDIO]];
}

-(void)popToRootVC{
    self.startViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AVKStartPromoViewController"];

    [self transitionFromViewController:self.authentificationVC toViewController:self.startViewController operation:(UINavigationControllerOperationPop)];
}

#pragma mark - VK AccessToken

- (void)vkAccessTokenHasBeenReceived:(VKAccessToken*)accessToken{
    // wait to get app changing animating complete
    [[[[BFTask taskWithDelay:500] continueWithBlock:^id(BFTask *task) {
        NSLog(@"%s",__PRETTY_FUNCTION__);
        return [[AVKStorage sharedStorage] valueForKey:AVKSessionTokenStorageKey];
    }] continueWithBlock:^id(BFTask *task) {
        NSLog(@"%s",__PRETTY_FUNCTION__);

        NSString* sessionToken = task.result;
        if (sessionToken.length) {
            return [PFUser becomeInBackground:sessionToken];
        }else {
            // Need sign up
            [self displaySignUpViewController];
            return nil;
        }
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSLog(@"%s",__PRETTY_FUNCTION__);

        if (task.result && !task.error) {
             [self presentHomeViewController];
         }else if (task.error.code == kPFErrorObjectNotFound){
             [[AVKStorage sharedStorage] setNilValueForKey:AVKSessionTokenStorageKey];
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
