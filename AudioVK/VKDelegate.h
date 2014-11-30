//
//  VKSdkDelegate.h
//  AudioVK
//
//  Created by Roman Gardukevich on 30.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk.h>

@interface VKDelegate : NSObject<VKSdkDelegate>
@property (nonatomic, weak) UIViewController* rootVC;
+(instancetype)sharedDelegate;
@end
