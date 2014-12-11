//
//  AUVAuthenticationTextField.m
//  AudioVK
//
//  Created by Roman Gardukevich on 12/10/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVAuthenticationTextField.h"
#import <Chameleon.h>

@interface AUVAuthenticationTextField ()

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@end

@implementation AUVAuthenticationTextField
@dynamic secureTextEntry, placeholder,text,  leftImageName;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"leftImageName"]) {
        UIImage* img = [UIImage imageNamed:value];
        self.imageView.image = img;
    }else {
        [self.textField setValue:value forKey:key];
        
    }
}

#pragma mark - properties to text field
-(NSString *)text{
    return self.textField.text;
}
-(void)setText:(NSString *)text{
    self.textField.text = text;
}

-(void)setPlaceholder:(NSString *)placeholder{
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1],
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18]}];
}

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
