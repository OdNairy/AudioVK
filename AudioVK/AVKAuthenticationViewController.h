//
//  AUVAuthenticationViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKBackgroundVideoView.h"

typedef NS_ENUM(NSUInteger, AUVAuthentificationVCState) {
    AUVAuthenticationVCStateSignIn,
    AUVAuthenticationVCStateSignUp
};


@interface AVKAuthenticationViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton* signInButton;

@property (nonatomic) AUVAuthentificationVCState state;
@property (nonatomic, strong) VKAccessToken* vkAccessToken;
@end
