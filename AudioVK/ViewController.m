//
//  ViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 27.11.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "ViewController.h"
#import <VKSdk.h>
#import "VKDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VKDelegate sharedDelegate].rootVC = self;
    [VKSdk authorize:@[@"audio"]];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
