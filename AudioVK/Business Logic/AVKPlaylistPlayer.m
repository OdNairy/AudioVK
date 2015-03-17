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
#import "AVKAudioCacheLayer.h"
#import <LMMediaPlayer.h>

NSString* const kAVKPlaylistPlayerWillChangeState = @"kAVKPlaylistPlayerWillChangeState";
NSString* const kAVKPlaylistPlayerWillStartPlaying = @"kAVKPlaylistPlayerWillStartPlaying";
NSString* const kAVKPlaylistPlayerDidStartPlaying = @"kAVKPlaylistPlayerDidStartPlaying";
NSString* const kAVKPlaylistPlayerDidFinishPlaying = @"kAVKPlaylistPlayerDidFinishPlaying";
NSString* const kAVKPlaylistPlayerDidStop = @"kAVKPlaylistPlayerDidStop";
NSString* const kAVKPlaylistPlayerDidChangeCurrentTime = @"kAVKPlaylistPlayerDidChangeCurrentTime";
NSString* const kAVKPlaylistPlayerDidChangeRepeatMode = @"kAVKPlaylistPlayerDidChangeRepeatMode";
NSString* const kAVKPlaylistPlayerDidChangeShuffleMode = @"kAVKPlaylistPlayerDidChangeShuffleMode";

NSString* const kAVKPlaylistPlayerStateKey = @"kAVKPlaylistPlayerStateKey";
NSString* const kAVKPlaylistPlayerMediaKey = @"kAVKPlaylistPlayerMediaKey";
NSString* const kAVKPlaylistPlayerRepeatModeKey = @"kAVKPlaylistPlayerRepeatModeKey";
NSString* const kAVKPlaylistPlayerShuffleModeKey = @"kAVKPlaylistPlayerShuffleModeKey";


@interface AVKPlaylistPlayer () <LMMediaPlayerDelegate>
@property(nonatomic, strong) LMMediaPlayer* player;
@property (nonatomic) BOOL shouldRestartQueue;

@property(nonatomic, assign) NSUInteger currentPlayingItemIndex;
@end

@implementation AVKPlaylistPlayer

+(instancetype)instance{
    static dispatch_once_t onceToken;
    static AVKPlaylistPlayer* player;
    dispatch_once(&onceToken, ^{
        player = [[AVKPlaylistPlayer alloc] init];
    });
    return player;
}

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
        NSURL* url = [NSURL URLWithString:audio.url];
        if (audio.fromCache) {
            url = [AVKAudioCacheLayer.instance resourceURLForCachedAudioId:audio.id];
        }
        LMMediaItem *mediaItem = [[LMMediaItem alloc] initWithInfo:
                                  @{LMMediaItemInfoContentTypeKey : @0,
                                    LMMediaItemInfoArtistKey:audio.artist,
                                    LMMediaItemInfoTitleKey :audio.title,
                                    LMMediaItemInfoURLKey :url,
                                    }];
//        LMMediaItemInfoArtworkKey :audio.cachedArtwork
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
    [self.player pause];
    if (self.shouldRestartQueue){
        self.shouldRestartQueue = NO;
        [self.player playAtIndex:0];
    } else {
        [self.player play];
    }
}

- (void)pause {
    [self.player pause];
}

- (void)stop{
    [self.player stop];
}
- (void)toggle{
    if (self.player.playbackState == LMMediaPlaybackStatePlaying) {
        [self pause];
    }else {
        [self play];
    }
}

- (void)next {
    [self.player playNextMedia];
}

- (void)previous {
    [self.player playPreviousMedia];
}

-(void)seekTo:(NSTimeInterval)time{
    [self.player pause];
    [self.player seekTo:time];
    [self.player play];
}

-(AVKMediaPlaybackState)playbackState{
    return (AVKMediaPlaybackState)self.player.playbackState;
}

#pragma mark - LMMediaPlayerDelegate

#define AVK_PLAYLIST_NOTIFICATION_NAME(A) kAVKPlaylistPlayer##A
#define _AVK_NOTIFICATION(NAME,DICT) [[NSNotificationCenter defaultCenter] postNotificationName:NAME \
            object:self \
          userInfo:DICT];
#define AVK_NOTIFICATION(NAME,DICT) _AVK_NOTIFICATION(AVK_PLAYLIST_NOTIFICATION_NAME(NAME),(DICT))


- (BOOL)mediaPlayerWillStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFICATION(WillStartPlaying, @{kAVKPlaylistPlayerMediaKey:media});
    
    [self.delegate playlistPlayer:self willPlayItem:media];
    return YES;
}

- (void)mediaPlayerWillChangeState:(LMMediaPlaybackState)state {
    AVK_NOTIFICATION(WillChangeState, @{kAVKPlaylistPlayerStateKey:@(state)});
}

- (void)mediaPlayerDidStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFICATION(DidStartPlaying, @{kAVKPlaylistPlayerMediaKey:media});
}

- (void)mediaPlayerDidFinishPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFICATION(DidFinishPlaying, @{kAVKPlaylistPlayerMediaKey:media});
}

- (void)mediaPlayerDidStop:(LMMediaPlayer *)player media:(LMMediaItem *)media {

    AVK_NOTIFICATION(DidStop, media?@{kAVKPlaylistPlayerMediaKey:media}:nil);
}

- (void)mediaPlayerDidChangeCurrentTime:(LMMediaPlayer *)player {
    AVK_NOTIFICATION(DidChangeCurrentTime, nil);
}

- (void)mediaPlayerDidChangeRepeatMode:(LMMediaRepeatMode)mode player:(LMMediaPlayer *)player {
    AVK_NOTIFICATION(DidChangeRepeatMode, @{kAVKPlaylistPlayerRepeatModeKey:@(mode)});
}

- (void)mediaPlayerDidChangeShuffleMode:(BOOL)enabled player:(LMMediaPlayer *)player {
    AVK_NOTIFICATION(DidChangeShuffleMode, @{kAVKPlaylistPlayerShuffleModeKey:@(enabled)});
}

@end
