//
//  PlayerRootViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKPlayerRootViewController.h"

#import "AVKPlayingNowViewController.h"
#import "AVKMyMusicVCDelegate.h"
#import <Masonry.h>
#import <LMMediaPlayer/LMMediaItem.h>

@interface AVKPlayerRootViewController () <AVKMyMusicVCDelegate>
@end


@implementation AVKPlayerRootViewController
const CGFloat minimumPlayingNowScreenPart = 60;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Playing Now VC
    [self initializePlayingNowVC];

    //  My music list
    [self initializeMyMusicVC];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self presentMyMusicVC:self.myMusicVC animeted:NO];
}

-(void)initializePlayingNowVC{
    self.playingNowVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AVKPlayingNowViewController class])];
    self.playingNowVC.rootDelegate = self;
    
    [self addChildViewController:self.playingNowVC];
    [self.view addSubview:self.playingNowVC.view];
    [self.playingNowVC didMoveToParentViewController:self];
    [self presentPlayingNowVC:self.playingNowVC animated:NO];
}

- (void)initializeMyMusicVC{
    self.myMusicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myMusicPlaylistNavigationVC"];
    AVKMyMusicPlaylistViewController *myMusic = [(UINavigationController *) self.myMusicVC viewControllers].firstObject;
    myMusic.delegate = self;
    
    [self addChildViewController:self.myMusicVC];
    [self.view addSubview:self.myMusicVC.view];
//    [self presentMyMusicVC:self.myMusicVC animeted:NO];
    [self.myMusicVC didMoveToParentViewController:self];
}


#pragma mark - Child View Controllers
-(void)presentPlayingNowVC:(AVKPlayingNowViewController*)playingNowVC animated:(BOOL)animated{
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    [playingNowVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).with.offset(-minimumPlayingNowScreenPart);
    }];
}

- (void)presentMyMusicVC:(AVKMyMusicPlaylistViewController*)myMusicVC animeted:(BOOL)animated{
    
    [myMusicVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLayoutGuide);
        make.left.right.equalTo(self.view);
//        make.right.equalTo(self.view);
        make.bottom.equalTo(self.playingNowVC.view.mas_top);
    }];
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

- (void)musicPlaylistVC:(AVKPlaylistViewController *)playlistViewController didSelectAudio:(VKAudio *)audio {
    [self.playingNowVC updateInfoByAudio:audio];
}

- (void)musicPlaylistVC:(AVKPlaylistViewController *)playlistVC willPlayMediaItem:(LMMediaItem *)mediaItem {
    [self.playingNowVC updateInfoByMediaItem:mediaItem];
}


@end
