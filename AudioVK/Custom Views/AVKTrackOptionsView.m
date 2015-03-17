//
//  AVKTrackOptionsView.m
//  AudioVK
//
//  Created by Intellectsoft on 13/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackOptionsView.h"
#import "AVKAudioCacheLayer.h"
#import <ACPDownloadView.h>

@interface AVKTrackOptionsView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToDownloadButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingConstraint;

@property (weak, nonatomic) IBOutlet ACPDownloadView* downloadView;
@end

@implementation AVKTrackOptionsView

-(void)awakeFromNib{
    [super awakeFromNib];
    __weak typeof(self) weakSelf = self;
    [self.downloadView setActionForTap:^(ACPDownloadView *downloadView, ACPDownloadStatus status) {
        [weakSelf downloadAudioButtonTapped];
    }];
}

-(void)setDownloadButtonActive:(BOOL)downloadButtonActive{
    [self setDownloadButtonActive:downloadButtonActive animated:NO];
}

-(void)setDownloadButtonActive:(BOOL)downloadButtonActive animated:(BOOL)animated{
    _downloadButtonActive = downloadButtonActive;
    [self.downloadView setIndicatorStatus:ACPDownloadStatusNone];
    
    void(^animationBlock)() = ^(void){
        // this is workaround to suppress constrainst warnings
        [self.titleTrailingConstraint setActive:NO];
        [self.titleToDownloadButtonConstraint setActive:NO];
        
        [self.titleTrailingConstraint setActive:!_downloadButtonActive];
        [self.titleToDownloadButtonConstraint setActive:_downloadButtonActive];
        self.hidden = !downloadButtonActive;
    };
    
    if (animated) {
        [UIView animateWithDuration:.2 animations:^{
            animationBlock();
            [self layoutIfNeeded];
        }];
    }else {
        animationBlock();
    }
    
}

-(void)downloadAudioButtonTapped{
    __weak typeof(self) weakSelf = self;
    NSLog(@"%s %@",__PRETTY_FUNCTION__,self.audio.id);
    [self.downloadView setIndicatorStatus:(ACPDownloadStatusRunning)];
    [[AVKAudioCacheLayer instance] cacheAudio:self.audio progression:^(VKAudio* audio, long long downloadedBytes, long long totalBytes) {
        [self.downloadView setProgress:(long double)downloadedBytes/totalBytes animated:NO];
        NSLog(@"Audio id: %@ progress: %Lf",audio.id, (long double)downloadedBytes/totalBytes);
    } completion:^(VKAudio* audio, BOOL cacheSuccess) {
        NSLog(@"Audio id: %@ has been cached.",audio.id);
        if ([self.audio.id isEqualToNumber:audio.id]) {
            audio.fromCache = cacheSuccess;
            [weakSelf setDownloadButtonActive:!cacheSuccess animated:YES];
        }
    }];
}

-(void)setAudio:(VKAudio *)audio{
    _audio = audio;
    self.downloadButtonActive = ![[AVKAudioCacheLayer instance] isAudioCachedOrCaching:audio.id];
}
@end
