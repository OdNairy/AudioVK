//
//  AVKPlaylistPlayer.h
//  AudioVK
//
//  Created by Intellectsoft on 10/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface AVKPlaylistPlayer : NSObject
@property(nonatomic, weak) id<AVKPlaylistPlayerDelegate> delegate;
@property (nonatomic, strong) NSArray* queue;
@property (nonatomic) AVKPlayerShuffleMode shuffleMode;
@property (nonatomic) AVKPlayerRepeatMode repeatMode;


-(void)play;
-(void)pause;
-(void)toggle;
-(void)next;
-(void)previous;
-(void)seekTo:(NSTimeInterval)time;


@end
