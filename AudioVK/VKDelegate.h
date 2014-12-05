//
//  VKSdkDelegate.h
//  AudioVK
//
//  Created by Roman Gardukevich on 30.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//


UIKIT_EXTERN NSString *const kVkDelegateUserIdKey;
UIKIT_EXTERN NSString *const kVkDelegateUserEmailKey;
UIKIT_EXTERN NSString *const kVkDelegateUserAccessTokenKey;

UIKIT_EXTERN NSString *const kVkDelegateNewTokenWasGiven;
UIKIT_EXTERN NSString *const kVkDelegateAccessHasBeenDenied;

typedef NS_OPTIONS(NSUInteger, VKAccessTokenEvents) {
    VKAccessTokenEventReceivedNew           = 1 <<  0,      // on all touch downs
    VKAccessTokenEventRenewed               = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    VKAccessTokenEventHasExpired            = 1 <<  2,
    VKAccessTokenEventCaptchaNeeded         = 1 <<  3,
    VKAccessTokenEventAccepted              = 1 <<  4,
    
    VKAccessTokenEventDenied                = 1 << 10,
    
    VKAccessTokenEventReceived              = VKAccessTokenEventRenewed | VKAccessTokenEventReceivedNew | VKAccessTokenEventAccepted
};

@interface VKDelegate : NSObject<VKSdkDelegate>
@property (nonatomic, weak) UIViewController* rootVC;
+ (instancetype)sharedDelegate;


@end


@interface VKDelegate (TargetAction)
- (void)addTarget:(id)target action:(SEL)action forAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents;
- (void)removeTarget:(id)target action:(SEL)action forAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents;

- (void)sendActionsForAccessTokenEvents:(VKAccessTokenEvents)accessTokenEvents vkAccessToken:(VKAccessToken*)vkAccessToken;
@end