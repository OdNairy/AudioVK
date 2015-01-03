//
//  AUVAuthenticationTextField.m
//  AudioVK
//
//  Created by Roman Gardukevich on 12/10/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKAuthenticationTextField.h"
#import <Chameleon.h>

@interface AVKAuthenticationTextField ()

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@end

@implementation AVKAuthenticationTextField
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
//    UIColor* foregroundColor = [UIColor colorWithRed:224.0/255 green:190.0/255 blue:153.0/255 alpha:0.7];
    UIColor* foregroundColor = [UIColor colorWithRed:119/255 green:107/255 blue:96/255 alpha:0.7];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                           attributes:@{NSForegroundColorAttributeName: foregroundColor,
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
