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
@property (nonatomic, strong) id periodicTimeObserver;
@property (nonatomic, weak) IBOutlet UIProgressView* progressView;
@end

NSString* stringFromCMTime(CMTime time)
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

@implementation AVKControlPanelView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.progressView.progress = 0;
    [[AVKPlaylistPlayer instance] addTarget:self action:@selector(updateToggleButtonState:) forControlEvents:(AVKPlaylistPlayerWillChangeStateEvent)];
    
    __weak typeof (self) weakSelf = self;
    CMTime interval = CMTimeMake(25, 100);

    self.periodicTimeObserver = [AVKPlaylistPlayer.instance.systemAVPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        AVPlayer* player = AVKPlaylistPlayer.instance.systemAVPlayer;
        
        CMTime endTime = CMTimeConvertScale (player.currentItem.asset.duration, player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            float normalizedTime = (float) player.currentTime.value / (double) endTime.value;
            [weakSelf.progressView setProgress:normalizedTime animated:NO];
        }else{
            [weakSelf.progressView setProgress:0 animated:NO];
        }
        
    }];
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

-(void)setPeriodicTimeObserver:(id)periodicTimeObserver{
    if (_periodicTimeObserver) {
        [AVKPlaylistPlayer.instance.systemAVPlayer removeTimeObserver:_periodicTimeObserver];
    }
    _periodicTimeObserver = periodicTimeObserver;
}

-(void)dealloc{
    self.periodicTimeObserver = nil;
}

@end
