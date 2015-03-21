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

// Target-Action implementation
@property (nonatomic, strong) NSMutableArray* registeredActions;

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

-(NSMutableArray *)registeredActions{
    if (!_registeredActions) {
        _registeredActions = [NSMutableArray array];
    }
    return _registeredActions;
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
        [mediaItem setArtworkImage:audio.cachedArtwork];
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

#pragma mark - Target-Action



#pragma mark - LMMediaPlayerDelegate

#define AVK_PLAYLIST_NOTIFICATION_NAME(A) kAVKPlaylistPlayer ## A
#define AVK_PLAYLIST_ACTION_NAME(A) AVKPlaylistPlayer ## A ## Event
#define _AVK_NOTIFICATION(NAME,ACTION,DICT) [[NSNotificationCenter defaultCenter] postNotificationName:NAME \
            object:self \
          userInfo:DICT];     [self sendActionsForControlEvents:ACTION params:DICT];
#define AVK_NOTIFY(NAME,DICT) _AVK_NOTIFICATION(AVK_PLAYLIST_NOTIFICATION_NAME(NAME),AVK_PLAYLIST_ACTION_NAME(NAME),(DICT))


- (BOOL)mediaPlayerWillStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFY(WillStartPlaying, media?@{kAVKPlaylistPlayerMediaKey:media}:nil);
    [self.delegate playlistPlayer:self willPlayItem:media];
    return YES;
}

- (void)mediaPlayerWillChangeState:(LMMediaPlaybackState)state {
    AVK_NOTIFY(WillChangeState, @{kAVKPlaylistPlayerStateKey:@(state)});
}

- (void)mediaPlayerDidStartPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFY(DidStartPlaying, @{kAVKPlaylistPlayerMediaKey:media});
}

- (void)mediaPlayerDidFinishPlaying:(LMMediaPlayer *)player media:(LMMediaItem *)media {
    AVK_NOTIFY(DidFinishPlaying, @{kAVKPlaylistPlayerMediaKey:media});
}

- (void)mediaPlayerDidStop:(LMMediaPlayer *)player media:(LMMediaItem *)media {

    AVK_NOTIFY(DidStop, media?@{kAVKPlaylistPlayerMediaKey:media}:nil);
}

- (void)mediaPlayerDidChangeCurrentTime:(LMMediaPlayer *)player {
    AVK_NOTIFY(DidChangeCurrentTime, nil);
}

- (void)mediaPlayerDidChangeRepeatMode:(LMMediaRepeatMode)mode player:(LMMediaPlayer *)player {
    AVK_NOTIFY(DidChangeRepeatMode, @{kAVKPlaylistPlayerRepeatModeKey:@(mode)});
}

- (void)mediaPlayerDidChangeShuffleMode:(BOOL)enabled player:(LMMediaPlayer *)player {
    AVK_NOTIFY(DidChangeShuffleMode, @{kAVKPlaylistPlayerShuffleModeKey:@(enabled)});
}

@end

@interface AVKTargetActionPair : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) AVKPlaylistPlayerEvents events;
@end
@implementation AVKTargetActionPair@end

@implementation AVKPlaylistPlayer (TargetAction)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(AVKPlaylistPlayerEvents)controlEvents{
    AVKTargetActionPair* pair = [[AVKTargetActionPair alloc] init];
    pair.target = target; pair.action = action; pair.events = controlEvents;
    [self.registeredActions addObject:pair];
}
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(AVKPlaylistPlayerEvents)controlEvents{
    for (NSInteger i = self.registeredActions.count -1; i>=0; --i) {
        AVKTargetActionPair* pair = self.registeredActions[i];
        if (pair.target == target) {
            pair.events &= !controlEvents;
            if (!pair.events) {
                [self.registeredActions removeObjectAtIndex:i];
            }
        }
    }
}

- (void)sendActionsForControlEvents:(AVKPlaylistPlayerEvents)controlEvents{
    [self sendActionsForControlEvents:controlEvents params:self];
}

- (void)sendActionsForControlEvents:(AVKPlaylistPlayerEvents)controlEvents params:(id)params{
    for (AVKTargetActionPair* pair in self.registeredActions) {
        if (pair.events & controlEvents) {
            ((void (*)(id, SEL, id))[pair.target methodForSelector:pair.action])(pair.target, pair.action, params);
        }
    }
}


@end
