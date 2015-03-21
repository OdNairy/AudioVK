//
//  AVKControlPanelView.m
//  AudioVK
//
//  Created by Intellectsoft on 08/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKControlPanelView.h"
#import "AVKPlaylistPlayer.h"

@interface AVKControlPanelView ()

@end

@implementation AVKControlPanelView

-(void)awakeFromNib{
    [super awakeFromNib];
    [[AVKPlaylistPlayer instance] addTarget:self action:@selector(updateToggleButtonState:) forControlEvents:(AVKPlaylistPlayerWillChangeStateEvent)];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToggleButtonState) name:kAVKPlaylistPlayerWillChangeState object:nil];
}

-(IBAction)toggleButtonTapped:(UIButton*)sender{
    [[AVKPlaylistPlayer instance] toggle];
}

- (void)updateToggleButtonState:(NSDictionary*)params{
    NSLog(@"stateUpdated: %@",@[@"Stop",@"Playing",@"Pause"][[params[kAVKPlaylistPlayerStateKey] unsignedIntegerValue]]);
    
    AVKMediaPlaybackState state = [params[kAVKPlaylistPlayerStateKey] unsignedIntegerValue];
    BOOL isPaused = state == AVKMediaPlaybackStatePaused;
    BOOL isPlaying = state == AVKMediaPlaybackStatePlaying;
    BOOL isStoped = state == AVKMediaPlaybackStateStopped;
    
    self.toggleButton.selected = isPlaying;
}

@end
