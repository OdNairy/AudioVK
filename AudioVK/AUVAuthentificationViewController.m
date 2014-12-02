//
//  AUVAuthentificationViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthentificationViewController.h"

#import <VKSdk.h>
#import "VKDelegate.h"
#import <Chameleon.h>

#import <AVFoundation/AVFoundation.h>

#define PERMISSIONS_ARRAY (@[@"audio",@"email",@"offline"])

@interface AUVAuthentificationViewController (NotificationMethods)
- (void)subscribeForNotifications;
- (void)unsubscribeFromNotifications;

- (void)vkAccessNewTokenWasGiven:(NSNotification*)accessTokenNotification;
- (void)vkAccessAccessHasBeenDenied:(NSNotification*)accessDeniedNotification;
@end

@interface AUVAuthentificationViewController ()
@property (nonatomic, copy) NSString* vkUserId;
@property (nonatomic, copy) NSString* vkUserAccessToken;
@property (nonatomic, copy) NSString* vkUserEmail;

@end

@implementation AUVAuthentificationViewController

#pragma mark - Lifecycle common usage
- (void)viewDidLoad {
    [super viewDidLoad];
    [self subscribeForNotifications];
    
    [self applyShadowForNavigationBar];
    [self.backgroundView playVideoByPath:[[NSBundle mainBundle] pathForResource:@"motionblock1" ofType:@"mp4"] inLoop:YES];
}

#pragma mark - UI
- (void)applyShadowForNavigationBar{
    CALayer* layer =     self.navigationController.navigationBar.layer;
    layer.shadowOffset = CGSizeMake(0, 1);
    layer.shadowOpacity = 0.8;
    layer.masksToBounds = NO;
}

#pragma mark - IB actions
- (IBAction)vkAuthentificationButtonTapped{
    [VKDelegate sharedDelegate].rootVC = self.navigationController;
    [VKSdk authorize:PERMISSIONS_ARRAY revokeAccess:YES];
}

-(IBAction)signInButtonTapped{
    
//    AVAsset* avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
//    AVPlayerItem* avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
//    AVPlayer* avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
//
//    AVPlayerLayer* avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
//    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    avPlayerLayer.frame = self.view.bounds;
//    [self.view.layer insertSublayer:avPlayerLayer atIndex:0];
//    avPlayerLayer.opacity = 0.5;
//    [avPlayer seekToTime:kCMTimeZero];
//    [avPlayer play];
}
#pragma mark - Custom Setters and Getters
-(void)setVkUserEmail:(NSString *)vkUserEmail{
    _vkUserEmail = vkUserEmail;
    self.emailTextField.text = vkUserEmail;
}

#pragma mark - Lifecycle rary usage
- (void)dealloc{
    [self unsubscribeFromNotifications];
}

@end


@implementation AUVAuthentificationViewController (NotificationMethods)

- (void)subscribeForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vkAccessNewTokenWasGiven:)
                                                 name:kVkDelegateNewTokenWasGiven object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vkAccessAccessHasBeenDenied:)
                                                 name:kVkDelegateAccessHasBeenDenied object:nil];
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)vkAccessNewTokenWasGiven:(NSNotification*)accessTokenNotification{
    self.vkUserId = accessTokenNotification.userInfo[kVkDelegateUserIdKey];
    self.vkUserAccessToken = accessTokenNotification.userInfo[kVkDelegateUserAccessTokenKey];
    self.vkUserEmail = accessTokenNotification.userInfo[kVkDelegateUserEmailKey];
}

- (void)vkAccessAccessHasBeenDenied:(NSNotification*)accessDeniedNotification{
    self.vkUserId = nil;
    self.vkUserAccessToken = nil;
    self.vkUserEmail = nil;
}



@end