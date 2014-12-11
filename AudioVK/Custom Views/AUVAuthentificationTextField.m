//
//  AUVAuthentificationTextField.m
//  AudioVK
//
//  Created by Roman Gardukevich on 12/10/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthentificationTextField.h"
#import <Chameleon.h>

@interface AUVAuthentificationTextField ()
@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@end

@implementation AUVAuthentificationTextField
@dynamic secureTextEntry, placeholder, text, leftImageName;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"leftImageName"]) {
        UIImage* img = [UIImage imageNamed:value];
        self.imageView.image = img;
    }else {
        [self.textField setValue:value forKey:key];
        
    }
}

//-(void)setLeftImageName:(NSString *)leftImageName{
//    UIImage* img = [UIImage imageNamed:leftImageName];
//    if (img) {
////        _leftImageName = leftImageName;
//        self.imageView.image = img;
//    }
//}

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    self.textField.secureTextEntry = secureTextEntry;
}

-(BOOL)secureTextEntry{
    return self.textField.secureTextEntry;
}

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder{
//self.layer.cornerRadius = 4;
//self.layer.masksToBounds = YES;
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)prepareForInterfaceBuilder{
    self.layer.cornerRadius = 4;

    self.backgroundColor = [UIColor clearColor];
}

@end
