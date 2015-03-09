//
//  AVKArtworkLoaderCache.h
//  AudioVK
//
//  Created by Intellectsoft on 08/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVKArtworkLoaderCache : NSObject
+ (instancetype)instance;

- (NSString *)objectForKeyedSubscript:(id <NSCopying>)key;

- (void)setObject:(NSString *)obj forKeyedSubscript:(id <NSCopying>)key;
@end
