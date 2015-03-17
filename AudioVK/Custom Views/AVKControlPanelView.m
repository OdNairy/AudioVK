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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToggleButtonState) name:kAVKPlaylistPlayerWillChangeState object:nil];
}

-(IBAction)toggleButtonTapped:(UIButton*)sender{
    [[AVKPlaylistPlayer instance] toggle];
    [self updateToggleButtonState];
}

- (void)updateToggleButtonState{
    self.toggleButton.selected = [[AVKPlaylistPlayer instance] playbackState] != AVKMediaPlaybackStatePlaying;
}

@end
