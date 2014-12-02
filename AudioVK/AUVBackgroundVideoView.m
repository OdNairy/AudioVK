//
//  AUVBackgroundVideoView.m
//  AudioVK
//
//  Created by Roman Gardukevich on 02.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AUVBackgroundVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface AUVBackgroundVideoView ()
@property (nonatomic,readonly,retain) AVPlayerLayer  *layer;
@property (nonatomic, strong) AVPlayer* avPlayer;
@end

@implementation AUVBackgroundVideoView
@dynamic layer;

+(Class)layerClass{
    return [AVPlayerLayer class];
}

- (void)playVideoByPath:(NSString *)filePath inLoop:(BOOL)inLoop{
    AVAsset* avAsset;
    if (inLoop) {
        avAsset = [self makeAssetCompositionForPath:filePath];
    }else {
        avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    }
    
    AVPlayerItem* avPlayerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    
    self.layer.player = self.avPlayer;
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.avPlayer play];
}

- (AVAsset*) makeAssetCompositionForPath:(NSString*)path {
    
    int numOfCopies = 50;
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    AVURLAsset* sourceAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    
    // calculate time
    CMTimeRange editRange = CMTimeRangeMake(CMTimeMake(0, 600), CMTimeMake(sourceAsset.duration.value, sourceAsset.duration.timescale));
    
    NSError *editError;
    
    // and add into your composition
    BOOL result = [composition insertTimeRange:editRange ofAsset:sourceAsset atTime:composition.duration error:&editError];
    
    if (result) {
        for (int i = 0; i < numOfCopies; i++) {
            [composition insertTimeRange:editRange ofAsset:sourceAsset atTime:composition.duration error:&editError];
        }
    }
    
    return composition;
}

@end
