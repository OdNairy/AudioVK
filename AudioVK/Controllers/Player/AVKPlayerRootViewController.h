//
//  PlayerRootViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVKViewController.h"
#import "AVKPlayerProtocol.h"
#import "AVKMyMusicPlaylistViewController.h"

@class AVKPlayingNowViewController, AVKPlaylistViewController;

@interface AVKPlayerRootViewController : AVKViewController<AVKPlayingNowVCProtocol>

@property (nonatomic, strong) AVKPlayingNowViewController* playingNowVC;

@property (nonatomic, strong) AVKPlaylistViewController* currentPlaylistVC;
@property (nonatomic, strong) AVKMyMusicPlaylistViewController* myMusicVC;
@property (nonatomic, strong) AVKPlaylistViewController* playlistsVC;
@end


