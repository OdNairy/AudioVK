//
//  PlayerRootViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKPlayerRootViewController.h"

#import "AVKPlayingNowViewController.h"
#import <Masonry.h>

@interface AVKPlayerRootViewController ()
@end


@implementation AVKPlayerRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playingNowVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AVKPlayingNowViewController class])];
    self.playingNowVC.rootDelegate = self;
    self.playingNowVC.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    [self addChildViewController:self.playingNowVC];
    [self.view addSubview:self.playingNowVC.view];
    [self.playingNowVC didMoveToParentViewController:self];
    
}

- (CGFloat)min{
    return self.view.bounds.size.height*0.2;
}

- (CGFloat)max{
    return self.view.bounds.size.height*0.985;
}




#pragma mark - Playing Now Delegate
- (void)playingNowVC:(AVKPlayingNowViewController*)playingNowVC show:(BOOL)show{
    [UIView animateWithDuration:.4 animations:^{
//        self.playingBottomTopConstraints.with.offset(show?self.max:self.min);
        [self.view layoutIfNeeded];
    }];
}

- (void)triggeredPlayingNowVC:(AVKPlayingNowViewController*)playingNowVC{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
