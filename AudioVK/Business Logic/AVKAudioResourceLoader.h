//
//  AVKCacheAudioLayer.h
//  TEST
//
//  Created by Roman Gardukevich on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class AVKAudioResourceLoader;


@protocol AVKCacheAudioProtocol <NSObject>

-(void)cacheAudioLayer:(AVKAudioResourceLoader*)cacheAudioLayer didFinishLoadingData:(NSData*)data;
-(void)cacheAUdioLayerHasBeenCanceled:(AVKAudioResourceLoader*)cacheAudioLayer;
@end


@interface AVKAudioResourceLoader : NSObject<AVAssetResourceLoaderDelegate>
@property (nonatomic,getter=isFinished, readonly) BOOL finished;
@property (nonatomic,getter=isCanceled, readonly) BOOL canceled;

@property (nonatomic, weak) id<AVKCacheAudioProtocol> delegate;
-(instancetype)initWithAudioURL:(NSURL*)audioURL cachePath:(NSURL*)cacheURL NS_DESIGNATED_INITIALIZER;

-(NSURL*)processedAudioURL;

- (void)cancel;

@end
