//
//  AUVAuthentificationViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVBackgroundVideoView.h"

typedef NS_ENUM(NSUInteger, AUVAuthentificationVCState) {
    AUVAuthentificationVCStateSignIn,
    AUVAuthentificationVCStateSignUp
};



@interface AUVAuthentificationViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton* signInButton;

@property (nonatomic, weak) IBOutlet UITextField* loginTextField;
@property (nonatomic, weak) IBOutlet UITextField* passwordTextField;

@property (nonatomic) AUVAuthentificationVCState state;
@property (nonatomic, strong) VKAccessToken* vkAccessToken;
@end
