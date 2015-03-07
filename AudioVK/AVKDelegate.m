//
//  VKSdkDelegate.m
//  AudioVK
//
//  Created by Roman Gardukevich on 30.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKDelegate.h"

NSString *const kVkDelegateUserIdKey = @"kVkDelegateUserIdKey";
NSString *const kVkDelegateUserEmailKey = @"kVkDelegateUserEmailKey";
NSString *const kVkDelegateUserAccessTokenKey = @"kVkDelegateUserTokenKey";

NSString *const kVkDelegateNewTokenWasGiven = @"kVkDelegateNewTokenWasGiven";
NSString *const kVkDelegateAccessHasBeenDenied = @"kVkDelegateAccessHasBeenDenied";

@interface AVKDelegate ()
@property (nonatomic, strong) NSMutableArray* targetsActions;
@end

@implementation AVKDelegate



+(instancetype)sharedDelegate{
    static dispatch_once_t onceToken;
    static AVKDelegate * delegate;
    dispatch_once(&onceToken, ^{
        delegate = [[AVKDelegate alloc] init];
    });
    return delegate;
}

#pragma mark Custom Getters and Setters
- (NSMutableArray *)targetsActions{
    if (!_targetsActions) {
        _targetsActions = [NSMutableArray array];
    }
    return _targetsActions;
}

#pragma mark - VKSDK protocol implementation
- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 Notifies delegate about existing token has expired
 @param expiredToken old token that has expired
 */
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 Notifies delegate about user authorization cancelation
 @param authorizationError error that describes authorization error
 */
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self sendActionsForAccessTokenEvents:(VKAccessTokenEventDenied) vkAccessToken:(id)authorizationError];
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
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self sendActionsForAccessTokenEvents:(VKAccessTokenEventReceivedNew) vkAccessToken:token];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self sendActionsForAccessTokenEvents:(VKAccessTokenEventAccepted) vkAccessToken:token];
}

- (void)vkSdkRenewedToken:(VKAccessToken *)newToken{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self sendActionsForAccessTokenEvents:(VKAccessTokenEventRenewed) vkAccessToken:newToken];
}
@end

@interface AUVTargetActionPair : NSObject{
    @package
    SEL _action;
    int _eventMask;
    id _target;
}
@end
@implementation AUVTargetActionPair
@end

@implementation AVKDelegate (TargetAction)
-(void)addTarget:(id)target action:(SEL)action forAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents{
    AUVTargetActionPair* pair = [[AUVTargetActionPair alloc] init];
    pair->_action = action; pair->_target = target; pair->_eventMask = accessTokenEvents;
    [self.targetsActions addObject:pair];
}
-(void)removeTarget:(id)target action:(SEL)action forAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents{
    for (NSInteger i = 0; i< self.targetsActions.count; i++){
        AUVTargetActionPair* pair = self.targetsActions[i];
        pair->_eventMask = pair->_eventMask & !accessTokenEvents;   // remove event mask
        if (!pair->_eventMask) {
            [self.targetsActions removeObjectAtIndex:i];
        }
    }
}

- (void)sendActionsForAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents vkAccessToken:(VKAccessToken*)vkAccessToken{
    for (NSInteger i = 0; i < self.targetsActions.count; i++) {
        AUVTargetActionPair* pair = self.targetsActions[i];
        if (pair->_eventMask & accessTokenEvents) {
            // call action for target
            ((void (*)(id, SEL, id))[pair->_target methodForSelector:pair->_action])(pair->_target, pair->_action, vkAccessToken);
        }
    }
}
@end
