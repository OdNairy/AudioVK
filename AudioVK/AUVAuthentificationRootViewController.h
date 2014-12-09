//
//  AUVAuthentificationRootViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 07.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AUVAuthentificationRootProtocol <NSObject>
@required
- (void)signInAction;
- (void)signInByVKAction;

@end


@interface AUVAuthentificationRootViewController : UIViewController<AUVAuthentificationRootProtocol>


@end


