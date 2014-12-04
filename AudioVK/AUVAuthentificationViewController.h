//
//  AUVAuthentificationViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 01.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVBackgroundVideoView.h"

@interface AUVAuthentificationViewController : UIViewController
@property (nonatomic, weak) IBOutlet AUVBackgroundVideoView* backgroundView;

@property (nonatomic, weak) IBOutlet UIButton* signInButton;

@property (nonatomic, weak) IBOutlet UITextField* emailTextField;
@property (nonatomic, weak) IBOutlet UITextField* passwordTextField;

@end
