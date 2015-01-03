//
//  AUVAuthenticationTextField.h
//  AudioVK
//
//  Created by Roman Gardukevich on 12/10/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+NibLoading.h>

IB_DESIGNABLE
@interface AVKAuthenticationTextField : NibLoadedView
@property (nonatomic, strong) IBInspectable IBOutlet UITextField* textField;

@property (nonatomic, copy) IBInspectable NSString* text;
@property (nonatomic, copy) IBInspectable NSString* leftImageName;
@property (nonatomic, copy) IBInspectable NSString* placeholder;

@property(nonatomic,getter=isSecureTextEntry) IBInspectable BOOL secureTextEntry;       // default is NO

@end
