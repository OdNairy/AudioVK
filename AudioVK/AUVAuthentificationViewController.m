//
//  AUVAuthentificationViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthentificationViewController.h"

#import "VKDelegate.h"
#import "VKStorage.h"
#import <Chameleon.h>

#import <AVFoundation/AVFoundation.h>

@interface AUVAuthentificationViewController ()
@property (nonatomic, copy) NSString* vkUserId;
@property (nonatomic, copy) NSString* vkUserAccessToken;
@property (nonatomic, copy) NSString* vkUserEmail;

@property (nonatomic, assign) BOOL isInSignUpState;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* signInTopConstraint;
@property (nonatomic, weak) IBOutlet UILabel* emailLabel;
@property (nonatomic, weak) IBOutlet UITextField* emailTextField;
@end

@implementation AUVAuthentificationViewController

-(void)awakeFromNib{
    self.state = AUVAuthentificationVCStateSignIn;
}

#pragma mark - Lifecycle common usage
- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField.text = self.vkAccessToken.email;
    
    [self applyShadowForNavigationBar];
    [self.backgroundView playVideoByPath:[[NSBundle mainBundle] pathForResource:@"moments" ofType:@"mp4"] inLoop:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.signInTopConstraint.constant = self.state == AUVAuthentificationVCStateSignIn? 20: 80;
    self.emailLabel.hidden = self.emailTextField.hidden = self.state == AUVAuthentificationVCStateSignIn;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
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
    [VKDelegate sharedDelegate].rootVC = self.navigationController;
    [VKSdk authorize:@[VK_PER_EMAIL, VK_PER_OFFLINE, VK_PER_AUDIO]];
}

-(IBAction)signInButtonTapped{
    if (self.state == AUVAuthentificationVCStateSignIn) {
        [PFUser logInWithUsernameInBackground:self.loginTextField.text
                                     password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            NSLog(@"Sign in as user: %@",user);
                                            self.vkUserAccessToken = user[@"VKAccessToken"];
                                            [user saveEventually];
                                        }];
        
    }else {
        PFUser* user = [PFUser user];
        user.username = self.loginTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        user[@"VKAccessToken"] = self.vkAccessToken.accessToken;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[[VKStorage sharedStorage] setValue:user.sessionToken forKey:@"AudioVKSessionToken"]
             continueWithSuccessBlock:^id(BFTask *task) {
                 NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
                 [self performSegueWithIdentifier:@"ShowDashboard" sender:self];
                 return nil;
             }];
//            
//            VKRequest* req = [VKRequest requestWithMethod:@"storage.set" andParameters:@{@"key":@"AudioVKSessionToken",@"value":user.sessionToken} andHttpMethod:@"GET"];
//            [req executeWithResultBlock:^(VKResponse *response) {
//                if ([response.json isEqualToNumber:@1]) {
//                    NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
//                }else {
//                    NSLog(@"Sign up failed");
//                }
//                [self resetUIToSignInAction];
//            } errorBlock:^(NSError *error) {
//                [self resetUIToSignInAction];
//            }];
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
- (void)setVkAccessToken:(VKAccessToken *)vkAccessToken{
    _vkAccessToken = vkAccessToken;
    if (vkAccessToken.email.length) {
        self.emailTextField.text = vkAccessToken.email;
    }
}
@end