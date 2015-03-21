//
//  AVKPlaylistPlayer.h
//  AudioVK
//
//  Created by Intellectsoft on 10/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVKPlayerControlProtocol.h"

@protocol AVKPlaylistPlayerDelegate;

typedef NS_ENUM(NSInteger, AVKPlayerShuffleMode) {
    AVKPlayerShuffleModeNone,
    AVKPlayerShuffleModeSongs,
    
    AVKPlayerShuffleModeAlbumn = AVKPlayerShuffleModeNone
};

typedef NS_ENUM(NSInteger, AVKPlayerRepeatMode) {
    AVKPlayerRepeatModeNone,
    AVKPlayerRepeatModeAll,
    AVKPlayerRepeatModeOne,
    
    AVKPlayerRepeatModeAlbumn = AVKPlayerRepeatModeNone
};

typedef NS_ENUM(NSUInteger, AVKMediaPlaybackState) {
    AVKMediaPlaybackStateStopped,
    AVKMediaPlaybackStatePlaying,
    AVKMediaPlaybackStatePaused
};

typedef NS_ENUM(NSUInteger, AVKPlaylistPlayerEvents) {
    AVKPlaylistPlayerWillChangeStateEvent       = 1 << 0,
    AVKPlaylistPlayerWillStartPlayingEvent      = 1 << 1,
    AVKPlaylistPlayerDidStartPlayingEvent       = 1 << 2,
    AVKPlaylistPlayerDidFinishPlayingEvent     = 1 << 3,
    AVKPlaylistPlayerDidStopEvent               = 1 << 4,
    AVKPlaylistPlayerDidChangeCurrentTimeEvent  = 1 << 5,
    AVKPlaylistPlayerDidChangeRepeatModeEvent   = 1 << 6,
    AVKPlaylistPlayerDidChangeShuffleModeEvent  = 1 << 7,
    
    AVKPlaylistPlayerPlayingEvents = AVKPlaylistPlayerWillStartPlayingEvent | AVKPlaylistPlayerDidStartPlayingEvent | AVKPlaylistPlayerDidFinishPlayingEvent
};

@interface AVKPlaylistPlayer : NSObject<AVKPlayerControlProtocol>
@property (nonatomic, readonly) AVKMediaPlaybackState playbackState;

@property(nonatomic, weak) id<AVKPlaylistPlayerDelegate> delegate;
@property (nonatomic, strong) NSArray* queue;
@property (nonatomic) AVKPlayerShuffleMode shuffleMode;
@property (nonatomic) AVKPlayerRepeatMode repeatMode;
+(instancetype)instance;

-(void)seekTo:(NSTimeInterval)time;

- (AVPlayer*)systemAVPlayer;

@end

@interface AVKPlaylistPlayer (TargetAction)
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(AVKPlaylistPlayerEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(AVKPlaylistPlayerEvents)controlEvents;
- (void)sendActionsForControlEvents:(AVKPlaylistPlayerEvents)controlEvents;
- (void)sendActionsForControlEvents:(AVKPlaylistPlayerEvents)controlEvents params:(id)params;

@end


// Notifications
extern NSString* const kAVKPlaylistPlayerWillStartPlaying;
extern NSString* const kAVKPlaylistPlayerWillChangeState;
extern NSString* const kAVKPlaylistPlayerDidStartPlaying;
extern NSString* const kAVKPlaylistPlayerDidFinishPlaying;
extern NSString* const kAVKPlaylistPlayerDidStop;
extern NSString* const kAVKPlaylistPlayerDidChangeCurrentTime;
extern NSString* const kAVKPlaylistPlayerDidChangeRepeatMode;
extern NSString* const kAVKPlaylistPlayerDidChangeShuffleMode;

// Keys for InfoDictionary
extern NSString* const kAVKPlaylistPlayerStateKey;
extern NSString* const kAVKPlaylistPlayerMediaKey;
extern NSString* const kAVKPlaylistPlayerRepeatModeKey;
extern NSString* const kAVKPlaylistPlayerShuffleModeKey;