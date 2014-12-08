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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self displayAuthentificationViewController];
    });
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
//    _authentificationVC.view.frame = self.contentView.bounds;
//    [self.contentView addSubview:_authentificationVC.view];
    [self addChildViewController:_authentificationVC];
        [_authentificationVC didMoveToParentViewController:self];
    [self transitionFromViewController:self.startViewController
                      toViewController:self.authentificationVC
                              duration:2
                               options:(UIViewAnimationOptionTransitionNone)
                            animations:^{
                                
                            } completion:^(BOOL finished) {
                                
                            }];
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
