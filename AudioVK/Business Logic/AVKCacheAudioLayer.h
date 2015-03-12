//
//  AVKCacheAudioLayer.h
//  TEST
//
//  Created by Roman Gardukevich on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class AVKCacheAudioLayer;


@protocol AVKCacheAudioProtocol <NSObject>

-(void)cacheAudioLayer:(AVKCacheAudioLayer*)cacheAudioLayer didFinishLoadingData:(NSData*)data;
-(void)cacheAUdioLayerHasBeenCanceled:(AVKCacheAudioLayer*)cacheAudioLayer;
@end


@interface AVKCacheAudioLayer : NSObject<AVAssetResourceLoaderDelegate>
@property (nonatomic, weak) id<AVKCacheAudioProtocol> delegate ;
-(instancetype)initWithAudioURL:(NSURL*)audioURL cachePath:(NSURL*)cacheURL NS_DESIGNATED_INITIALIZER;

-(NSURL*)processedAudioURL;

- (void)cancel;

@end
