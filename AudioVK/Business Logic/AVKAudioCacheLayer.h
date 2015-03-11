//
//  AVKAudioCacheLayer.h
//  AudioVK
//
//  Created by Intellectsoft on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVKAudioCacheLayer : NSObject
+ (instancetype)instance;
- (BOOL)isAudioCachedForId:(NSNumber*)audioId;
- (NSURL*)resourceURLForCachedAudioId:(NSNumber*)audioId;
@end
