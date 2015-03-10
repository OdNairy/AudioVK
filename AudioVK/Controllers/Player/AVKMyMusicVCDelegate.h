//
// Created by Intellectsoft on 09/03/15.
// Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVKPlaylistViewController;
@class LMMediaItem;

@protocol AVKMyMusicVCDelegate <NSObject>
- (void)musicPlaylistVC:(AVKPlaylistViewController *)playlistViewController didSelectAudio:(VKAudio *)audio;
- (void)musicPlaylistVC:(AVKPlaylistViewController *)playlistVC willPlayMediaItem:(LMMediaItem *)mediaItem;
@end