//
//  AVKAudioCacheLayer.h
//  AudioVK
//
//  Created by Intellectsoft on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AudioCacheProgressionBlock)(VKAudio* audio, long long downloadedBytes, long long totalBytes);
typedef void(^AudioCacheCompletionBlock)(VKAudio* audio, BOOL success);

@interface AVKAudioCacheLayer : NSObject
+ (instancetype)instance;

- (BOOL)isAudioCachedForId:(NSNumber*)audioId;
- (BOOL)isAudioCachingRightNow:(NSNumber*)audioId;
- (BOOL)isAudioCachedOrCaching:(NSNumber*)audioId;

- (NSURL*)resourceURLForCachedAudioId:(NSNumber*)audioId;

- (void)cacheAudio:(VKAudio*)audio progression:(AudioCacheProgressionBlock)progressionBlock completion:(AudioCacheCompletionBlock)completionBlock;

@end
