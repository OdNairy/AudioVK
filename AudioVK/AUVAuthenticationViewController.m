//
//  AUVAuthenticationViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthenticationViewController.h"

#import "AUVAuthenticationRootViewController.h"
#import "AUVAuthenticationTextField.h"

#import "VKDelegate.h"
#import "VKStorage.h"
#import <Chameleon.h>

#import <AVFoundation/AVFoundation.h>

@interface AUVAuthenticationViewController ()
@property (nonatomic, copy) NSString* vkUserId;
@property (nonatomic, copy) NSString* vkUserAccessToken;
@property (nonatomic, copy) NSString* vkUserEmail;

@property (nonatomic, assign) BOOL isInSignUpState;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* signInTopConstraint;

@property (nonatomic, weak) IBOutlet AUVAuthenticationTextField * loginTextFieldWrapper;
@property (nonatomic, weak) IBOutlet AUVAuthenticationTextField * passwordTextFieldWrapper;
@property (nonatomic, weak) IBOutlet AUVAuthenticationTextField * emailTextFieldWrapper;

@property(nonatomic,readonly) AUVAuthenticationRootViewController *parentViewController;
@end

@implementation AUVAuthenticationViewController

-(void)awakeFromNib{
    self.state = AUVAuthentificationVCStateSignIn;
}

#pragma mark - Lifecycle common usage
- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextFieldWrapper.textField.text = self.vkAccessToken.email;
    
    [self applyShadowForNavigationBar];
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
    self.signInTopConstraint.constant = self.state == AUVAuthentificationVCStateSignIn? 34: 80;
    self.emailTextFieldWrapper.hidden = self.state == AUVAuthentificationVCStateSignIn;
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
    [self.parentViewController signInByVKAction];
}

-(IBAction)signInButtonTapped{
    NSString* login = self.loginTextFieldWrapper.text;
    NSString* password = self.passwordTextFieldWrapper.text;
    NSString* email = self.emailTextFieldWrapper.text;
    
    if (self.state == AUVAuthentificationVCStateSignIn) {
        [PFUser logInWithUsernameInBackground:login
                                     password:password
                                        block:^(PFUser *user, NSError *error) {
                                            NSLog(@"Sign in as user: %@",user);
                                            self.vkUserAccessToken = user[@"VKAccessToken"];
                                            [user saveEventually];
                                        }];
        
    }else {
        PFUser* user = [PFUser user];
        user.username = login;
        user.password = password;
        user.email = email;
        user[@"VKAccessToken"] = self.vkAccessToken.accessToken;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[[VKStorage sharedStorage] setValue:user.sessionToken forKey:AVKSessionTokenStorageKey]
             continueWithSuccessBlock:^id(BFTask *task) {
                 NSLog(@"Sign up as user: %@ [token: %@]",[PFUser currentUser],[PFUser currentUser].sessionToken);
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