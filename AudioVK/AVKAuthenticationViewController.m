//
//  AUVAuthenticationViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKAuthenticationViewController.h"

#import "AVKAuthenticationRootViewController.h"
#import "AVKAuthenticationTextField.h"

#import "AVKDelegate.h"
#import "AVKStorage.h"
#import <Chameleon.h>

#import <AVFoundation/AVFoundation.h>

@interface AVKAuthenticationViewController ()
@property (nonatomic, copy) NSString* vkUserId;
@property (nonatomic, copy) NSString* vkUserAccessToken;
@property (nonatomic, copy) NSString* vkUserEmail;

@property (nonatomic, assign) BOOL isInSignUpState;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* signInTopConstraint;

@property (nonatomic, weak) IBOutlet AVKAuthenticationTextField * loginTextFieldWrapper;
@property (nonatomic, weak) IBOutlet AVKAuthenticationTextField * passwordTextFieldWrapper;
@property (nonatomic, weak) IBOutlet AVKAuthenticationTextField * emailTextFieldWrapper;

@property(nonatomic,readonly) AVKAuthenticationRootViewController *parentViewController;
@end

@implementation AVKAuthenticationViewController

-(void)awakeFromNib{
    self.state = AUVAuthenticationVCStateSignIn;
}

#pragma mark - Lifecycle common usage
- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextFieldWrapper.textField.text = self.vkAccessToken.email;
    
    [self applyShadowForNavigationBar];
    [[[[PFUser query] fromPin] getFirstObjectInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        PFUser* user = task.result;
        return user;
//        [PFUser become:user.sessionToken];
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self updateStateUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.loginTextFieldWrapper.textField becomeFirstResponder];

}

-(void)setState:(AUVAuthentificationVCState)state{
    _state = state;
    [self updateStateUI];
}

- (void)updateStateUI{
    self.signInTopConstraint.constant = self.state == AUVAuthenticationVCStateSignIn ? 34: 80;
    self.emailTextFieldWrapper.hidden = self.state == AUVAuthenticationVCStateSignIn;
    [self.signInButton setTitle:[self titleForCurrentState]
                       forState:(UIControlStateNormal)];
}

- (NSString*)titleForCurrentState{
    if (self.state == AUVAuthenticationVCStateSignUp) {
        return NSLocalizedString(@"Sign UP", @"Sign up button title on authentication screen");
    }else {
        return NSLocalizedString(@"Sign IN", @"Sign IN button title on authentication screen");
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
- (IBAction)vkAuthenticationButtonTapped {
    [self.parentViewController signInByVKAction];
}

-(IBAction)signInButtonTapped{
    NSString* login = self.loginTextFieldWrapper.text;
    NSString* password = self.passwordTextFieldWrapper.text;
    NSString* email = self.emailTextFieldWrapper.text;
    
    if (self.state == AUVAuthenticationVCStateSignIn) {
        [PFUser logInWithUsernameInBackground:login
                                     password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user && !error) {
                                                NSLog(@"Sign in as user: %@",user);
                                                self.vkUserAccessToken = user[@"VKAccessToken"];
                                                [user saveEventually];
                                                [user pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                    
                                                }];
                                                [self.parentViewController presentHomeViewController];
                                            }
                                        }];
        
    }else {
        PFUser* user = [PFUser user];
        user.username = login;
        user.password = password;
        user.email = email;
        user[@"VKAccessToken"] = self.vkAccessToken.accessToken;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[[AVKStorage sharedStorage] setValue:user.sessionToken forKey:AVKSessionTokenStorageKey]
             continueWithSuccessBlock:^id(BFTask *task) {
                 NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
                 [[[PFUser currentUser] pinInBackground] continueWithSuccessBlock:^id(BFTask *task) {
                     NSLog(@"PIN task: %@",task.result);
                     return nil;
                 }];
                 [self.parentViewController presentHomeViewController];
//                 [self performSegueWithIdentifier:@"ShowDashboard" sender:self];
                 return nil;
             }];
        }];
    }
}

- (IBAction)hideKeyboardGestureTapped{
    [self.view endEditing:YES];
}

- (IBAction)backButtonTapped{
    [self.view endEditing:NO];
    [self.parentViewController popToRootVC];
}

- (void)performSignUpUIAction{
    self.isInSignUpState = YES;
    [self.signInButton setTitle:@"Sign UP" forState:(UIControlStateNormal)];
}

- (void)resetUIToSignInAction{
    self.isInSignUpState = NO;
    [self.signInButton setTitle:@"Sign IN" forState:(UIControlStateNormal)];

}

-(void)prepareForInterfaceBuilder{
    self.view.backgroundColor = [UIColor grayColor];
}

#pragma mark - Debug methods

#pragma mark - Custom Setters and Getters
- (void)setVkAccessToken:(VKAccessToken *)vkAccessToken{
    _vkAccessToken = vkAccessToken;
    if (vkAccessToken.email.length) {
        self.emailTextFieldWrapper.text = vkAccessToken.email;
    }
}
@end