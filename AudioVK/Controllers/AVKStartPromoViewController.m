//
//  AVKStartPromoViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 03.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKStartPromoViewController.h"

#import "AUVAuthenticationRootViewController.h"

@interface AVKStartPromoViewController ()
@property(nonatomic,readonly) AUVAuthenticationRootViewController *parentViewController;
@end

@implementation AVKStartPromoViewController
@dynamic parentViewController;

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - IB actions
- (IBAction)vkAuthentificationButtonTapped{
    [self.parentViewController signInByVKAction];
}


- (IBAction)signInButtonTapped{
    [self.parentViewController signInAction];
}
@end
