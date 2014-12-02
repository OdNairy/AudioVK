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
    AVAsset* avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    AVPlayerItem* avPlayerItem =[[AVPlayerItem alloc] initWithAsset:avAsset];
    self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    
    self.layer.player = self.avPlayer;
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.avPlayer play];
}


@end
