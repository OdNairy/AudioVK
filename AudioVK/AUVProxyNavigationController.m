//
//  AUVProxyNavigationController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 07.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVProxyNavigationController.h"

@interface AUVProxyNavigationController ()

@end

@implementation AUVProxyNavigationController

-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0){
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0){
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
