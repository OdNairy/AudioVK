//
//  VKSdkDelegate.m
//  AudioVK
//
//  Created by Roman Gardukevich on 30.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "VKDelegate.h"

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
    
}

/**
 Notifies delegate about existing token has expired
 @param expiredToken old token that has expired
 */
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    
}

/**
 Notifies delegate about user authorization cancelation
 @param authorizationError error that describes authorization error
 */
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    
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
- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    
}
@end
