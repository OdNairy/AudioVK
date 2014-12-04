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

#import <Parse/Parse.h>


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

@property (nonatomic, assign) BOOL isInSignUpState;
@end

@implementation AUVAuthentificationViewController

#pragma mark - Lifecycle common usage
- (void)viewDidLoad {
    [super viewDidLoad];
    [self subscribeForNotifications];
    
    [self applyShadowForNavigationBar];
    [self.backgroundView playVideoByPath:[[NSBundle mainBundle] pathForResource:@"moments" ofType:@"mp4"] inLoop:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.parentViewController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - UI
- (void)applyShadowForNavigationBar{
    CALayer* layer = self.navigationController.navigationBar.layer;
    layer.shadowOffset = CGSizeMake(0, 1);
    layer.shadowOpacity = 0.8;
    layer.masksToBounds = NO;
}

#pragma mark - IB actions
- (IBAction)vkAuthentificationButtonTapped{
//    [VKDelegate sharedDelegate].rootVC = self.navigationController;
//    [VKSdk authorize:PERMISSIONS_ARRAY revokeAccess:YES];
    
//    PFUser* user = [PFUser user];
//    user.username = @"OdNairy";
//    user.password = @"s";
//    user[@"phone"] = @"375259333256";
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//    }];
    
    
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        
//    }];
}

-(IBAction)signInButtonTapped{
    if (!self.isInSignUpState) {
        [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                     password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            NSLog(@"Sign in as user: %@",user);
                                            self.vkUserAccessToken = user[@"VKAccessToken"];
                                            [user saveEventually];
                                        }];
        
    }else {
        PFUser* user = [PFUser user];
        user.username = self.emailTextField.text;
        user.password = self.passwordTextField.text;
        user[@"VKAccessToken"] = self.vkUserAccessToken;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            VKRequest* req = [VKRequest requestWithMethod:@"storage.set" andParameters:@{@"key":@"AudioVKSessionToken",@"value":user.sessionToken} andHttpMethod:@"GET"];
            [req executeWithResultBlock:^(VKResponse *response) {
                if ([response.json isEqualToNumber:@1]) {
                    NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
                }else {
                    NSLog(@"Sign up failed");
                }
                [self resetUIToSignInAction];
            } errorBlock:^(NSError *error) {
                [self resetUIToSignInAction];
            }];
        }];
    }
}

- (IBAction)resetVKStorage{
    VKRequest* req = [VKRequest requestWithMethod:@"storage.set" andParameters:@{@"key":@"AudioVKSessionToken"} andHttpMethod:@"GET"];
    [req executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isEqualToNumber:@1]) {
            NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
        }else {
            NSLog(@"Sign up failed");
        }
    } errorBlock:^(NSError *error) {
        
    }];

}

- (void)performSignUpUIAction{
    self.isInSignUpState = YES;
    [self.signInButton setTitle:@"Sign UP" forState:(UIControlStateNormal)];
}

- (void)resetUIToSignInAction{
    self.isInSignUpState = NO;
    [self.signInButton setTitle:@"Sign IN" forState:(UIControlStateNormal)];

}

#pragma mark - Debug methods

#pragma mark - Custom Setters and Getters
- (void)setVkUserEmail:(NSString *)vkUserEmail{
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
    
    VKRequest* req = [VKRequest requestWithMethod:@"storage.get" andParameters:@{@"key":@"AudioVKSessionToken"} andHttpMethod:@"GET"];
    [req executeWithResultBlock:^(VKResponse *response) {
        NSString* sessionToken = (NSString*)response.json;
        if (!sessionToken.length) {
            [self performSignUpUIAction];
        }else {
            [PFUser becomeInBackground:sessionToken block:^(PFUser *user, NSError *error) {
                NSLog(@"Become user: %@",user);
            }];
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)vkAccessAccessHasBeenDenied:(NSNotification*)accessDeniedNotification{
    self.vkUserId = nil;
    self.vkUserAccessToken = nil;
    self.vkUserEmail = nil;
}



@end