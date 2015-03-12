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

-(IBAction)toggleButtonTapped:(UIButton*)sender{
    [[AVKPlaylistPlayer instance] toggle];
    self.toggleButton.selected = [[AVKPlaylistPlayer instance] playbackState] == AVKMediaPlaybackStatePlaying;
}

@end
