//
//  AVKAudioCacheLayer.m
//  AudioVK
//
//  Created by Intellectsoft on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKAudioCacheLayer.h"

@implementation AVKAudioCacheLayer
+ (instancetype)instance{
    static dispatch_once_t onceToken;
    static AVKAudioCacheLayer* cacheLayer;
    dispatch_once(&onceToken, ^{
        cacheLayer = [[AVKAudioCacheLayer alloc] init];
    });
    return cacheLayer;
}
- (BOOL)isAudioCachedForId:(NSNumber*)audioId{
    return NO;
}
- (NSURL*)resourceURLForCachedAudioId:(NSNumber*)audioId{
    return [[NSBundle mainBundle] URLForResource:@"out" withExtension:@"mp3"];
}
@end
