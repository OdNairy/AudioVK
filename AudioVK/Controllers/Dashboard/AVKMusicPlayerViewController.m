//
//  AVKMusicPlayerViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/3/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKMusicPlayerViewController.h"

@interface AVKMusicPlayerViewController ()

@end

@implementation AVKMusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.slider setThumbImage:[UIImage imageNamed:@"cursor"] forState:(UIControlStateNormal)];
}


@end
