//
//  AVKArtworkLoaderCache.m
//  AudioVK
//
//  Created by Intellectsoft on 08/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKArtworkLoaderCache.h"


@interface AVKArtworkLoaderCache ()
@property(nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation AVKArtworkLoaderCache
+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static AVKArtworkLoaderCache *cache;
    dispatch_once(&onceToken, ^{
        cache = [[AVKArtworkLoaderCache alloc] init];
    });
    return cache;
}

- (NSMutableDictionary *)cache {
    if (!_cache) {
        _cache = [NSMutableDictionary dictionary];
    }
    return _cache;
}

- (NSString *)objectForKeyedSubscript:(id <NSCopying>)key {
    return [self.cache objectForKeyedSubscript:key];
}

- (void)setObject:(NSString *)obj forKeyedSubscript:(id <NSCopying>)key {
    self.cache[key] = obj;
}
@end
