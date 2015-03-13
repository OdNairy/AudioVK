//
//  AVKTrackOptionsView.m
//  AudioVK
//
//  Created by Intellectsoft on 13/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackOptionsView.h"
#import "AVKAudioCacheLayer.h"

@interface AVKTrackOptionsView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToDownloadButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingConstraint;

@end

@implementation AVKTrackOptionsView

-(void)setDownloadButtonActive:(BOOL)downloadButtonActive{
    _downloadButtonActive = downloadButtonActive;
    
    // this is workaround to suppress constrainst warnings
    [self.titleTrailingConstraint setActive:NO];
    [self.titleToDownloadButtonConstraint setActive:NO];
    
    [self.titleTrailingConstraint setActive:!_downloadButtonActive];
    [self.titleToDownloadButtonConstraint setActive:_downloadButtonActive];
    self.hidden = !downloadButtonActive;
}

-(IBAction)downloadAudioButtonTapped:(id)sender{
    __weak typeof(self) weakSelf = self;
    NSLog(@"%s %@",__PRETTY_FUNCTION__,self.audio.id);
    [[AVKAudioCacheLayer instance] cacheAudio:self.audio progression:^(VKAudio* audio, long long downloadedBytes, long long totalBytes) {
        NSLog(@"Audio id: %@ progress: %Lf",audio.id, (long double)downloadedBytes/totalBytes);
    } completion:^(VKAudio* audio, BOOL cacheSuccess) {
        NSLog(@"Audio id: %@ has been cached.",audio.id);
        if ([self.audio.id isEqualToNumber:audio.id]) {
            audio.fromCache = YES;
            weakSelf.downloadButtonActive = !cacheSuccess;
        }
    }];
}

-(void)setAudio:(VKAudio *)audio{
    _audio = audio;
    self.downloadButtonActive = ![[AVKAudioCacheLayer instance] isAudioCachedOrCaching:audio.id];
}
@end
