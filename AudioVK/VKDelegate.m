//
//  VKSdkDelegate.m
//  AudioVK
//
//  Created by Roman Gardukevich on 30.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "VKDelegate.h"

NSString *const kVkDelegateUserIdKey = @"kVkDelegateUserIdKey";
NSString *const kVkDelegateUserEmailKey = @"kVkDelegateUserEmailKey";
NSString *const kVkDelegateUserAccessTokenKey = @"kVkDelegateUserTokenKey";

NSString *const kVkDelegateNewTokenWasGiven = @"kVkDelegateNewTokenWasGiven";
NSString *const kVkDelegateAccessHasBeenDenied = @"kVkDelegateAccessHasBeenDenied";

@implementation VKDelegate

+(instancetype)sharedDelegate{
    static dispatch_once_t onceToken;
    static VKDelegate* delegate;
    dispatch_once(&onceToken, ^{
        delegate = [[VKDelegate alloc] init];
    });
    return delegate;
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    NSLog(@"Need captcha");
}

/**
 Notifies delegate about existing token has expired
 @param expiredToken old token that has expired
 */
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    NSLog(@"Token expired");
}

/**
 Notifies delegate about user authorization cancelation
 @param authorizationError error that describes authorization error
 */
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    NSLog(@"User denied access");
    [[NSNotificationCenter defaultCenter] postNotificationName:kVkDelegateAccessHasBeenDenied object:self];
}

/**
 Pass view controller that should be presented to user. Usually, it's an authorization window
 @param controller view controller that must be shown to user
 */
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    UIViewController* viewVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [viewVC presentViewController:controller animated:YES completion:^{
        
    }];
}

/**
 Notifies delegate about receiving new access token
 @param newToken new token for API requests
 */
- (void)vkSdkReceivedNewToken:(VKAccessToken *)token{
    [self vkSdkPerformToken:token];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token{
    NSLog(@"Accepted token");
    [self vkSdkPerformToken:token];
}

- (void)vkSdkRenewedToken:(VKAccessToken *)newToken{
    NSLog(@"Renewed token");
    [self vkSdkPerformToken:newToken];
}

- (void)vkSdkPerformToken:(VKAccessToken*)token{
    NSLog(@"Token: %@",token);
    NSLog(@"Email: %@",token.email);
    
    NSMutableDictionary* newTokenUserInfo = [NSMutableDictionary dictionary];
    newTokenUserInfo[kVkDelegateUserIdKey] = token.userId;
    newTokenUserInfo[kVkDelegateUserAccessTokenKey] = token.accessToken;
    if (token.email)
        newTokenUserInfo[kVkDelegateUserEmailKey] = token.email;
    NSNotification* newTokenNotification = [[NSNotification alloc] initWithName:(NSString*)kVkDelegateNewTokenWasGiven
                                                                         object:self
                                                                       userInfo:newTokenUserInfo];
    [[NSNotificationCenter defaultCenter] postNotification:newTokenNotification];
}
@end
