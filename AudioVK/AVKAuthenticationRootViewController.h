//
//  AUVAuthenticationRootViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 07.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AVKAuthentificationRootProtocol <NSObject>
@required
- (void)signInAction;
- (void)signInByVKAction;

- (void)presentHomeViewController;

- (void)popToRootVC;
@end


@interface AVKAuthenticationRootViewController : UIViewController<AVKAuthentificationRootProtocol>


@end


