//
// Created by Intellectsoft on 10/03/15.
// Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVKPlaylistPlayer;
@class LMMediaItem;

@protocol AVKPlaylistPlayerDelegate <NSObject>
- (void)playlistPlayer:(AVKPlaylistPlayer *)playlistPlayer willPlayItem:(LMMediaItem *)mediaItem;
@end