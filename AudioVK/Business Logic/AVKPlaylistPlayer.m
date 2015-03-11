//
//  AVKPlaylistPlayer.m
//  AudioVK
//
//  Created by Intellectsoft on 10/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <LMMediaPlayer/LMMediaItem.h>
#import "AVKPlaylistPlayer.h"
#import "LMMediaPlayer.h"
#import "AVKPlaylistPlayerDelegate.h"
#import "VKAudio+Artwork.h"
#import <LMMediaPlayer.h>


@interface AVKPlaylistPlayer () <LMMediaPlayerDelegate>
@property(nonatomic, strong) LMMediaPlayer* player;
@property (nonatomic) BOOL shouldRestartQueue;

@property(nonatomic, assign) NSUInteger currentPlayingItemIndex;
@end

@implementation AVKPlaylistPlayer


- (instancetype)init {
    self = [super init];
    if (self) {
        self.player.delegate = self;
    }
    return self;
}

- (void)setQueue:(NSArray *)queue {
    _queue = queue;
    [self.player removeAllMediaInQueue];
    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    for (VKAudio *audio in queue){
        LMMediaItem *mediaItem = [[LMMediaItem alloc] initWithInfo:@{LMMediaItemInfoContentTypeKey:@0}];
        mediaItem.title = audio.title;
        mediaItem.artist = audio.artist;
        [mediaItem setArtworkImage:audio.cachedArtwork];
        mediaItem.assetURL = [[NSURL alloc] initWithString:audio.url];
        [mediaArray addObject:mediaItem];
    }
    [self.player setQueue:mediaArray];
    self.shouldRestartQueue = YES;
}

- (LMMediaPlayer *)player {
    return [LMMediaPlayer sharedPlayer];
}


- (void)setCurrentPlayingItemIndex:(NSUInteger)currentPlayingItemIndex {
    _currentPlayingItemIndex = currentPlayingItemIndex;
}

- (void)play {
    [self.player stop];
    if (self.shouldRestartQueue){
        [self.player playAtIndex:0];
    } else {
        [self.player play];
    }
}

- (void)pause {
    [self.player pause];
}

- (void)next {
    [self.player playNextMedia];
}

- (void)previous {
    [self.player playPreviousMedia];
}

#pragma mark - LMMediaPlayerDelegate
- (BOOL)mediaPlayerWillStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    [self.delegate playlistPlayer:self willPlayItem:media];
    return YES;
}

- (void)mediaPlayerWillChangeState:(LMMediaPlaybackState)state {

}

- (void)mediaPlayerDidStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {

}

- (void)mediaPlayerDidFinishPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {

}

- (void)mediaPlayerDidStop:(LMMediaPlayer *)player media:(LMMediaItem *)media {

}

- (void)mediaPlayerDidChangeCurrentTime:(LMMediaPlayer *)player {

}

- (void)mediaPlayerDidChangeRepeatMode:(LMMediaRepeatMode)mode player:(LMMediaPlayer *)player {

}

- (void)mediaPlayerDidChangeShuffleMode:(BOOL)enabled player:(LMMediaPlayer *)player {

}

@end
