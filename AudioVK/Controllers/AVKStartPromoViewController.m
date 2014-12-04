//
//  AVKStartPromoViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 03.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKStartPromoViewController.h"
#import "VKDelegate.h"

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

#pragma mark - IB actions
- (IBAction)vkAuthentificationButtonTapped{
    [VKDelegate sharedDelegate].rootVC = self.navigationController;

    [VKSdk authorize:PERMISSIONS_ARRAY];
}

#pragma mark - Target Action
- (IBAction)vkAccessTokenHasBeenReceived:(VKAccessToken*)accessToken{
    [self performSegueWithIdentifier:@"ShowLogIn" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
