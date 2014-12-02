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
    [self flatify];
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