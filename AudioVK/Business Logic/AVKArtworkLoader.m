//
//  AVKArtworkLoader.m
//  AudioVK
//
//  Created by Roman Gardukevich on 07/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKArtworkLoader.h"
#import "NSURLConnection+PromiseKit.h"
#import <Regexer.h>
#import <SDImageCache.h>
#import <PromiseKit/Promise.h>

@interface AVKArtworkLoader ()
@property(nonatomic, strong) SDImageCache *cache;
@end

@implementation AVKArtworkLoader
NSString *encodeString(NSString *string) {
    static CFStringRef charset = CFSTR("!@#$%&*()'\";:=,/?[]");
    CFStringRef str = (__bridge CFStringRef) string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static AVKArtworkLoader *loader;
    dispatch_once(&onceToken, ^{
        loader = [[AVKArtworkLoader alloc] init];
    });
    return loader;
}

- (SDImageCache *)cache {
    if (!_cache) {
        _cache = [SDImageCache sharedImageCache];
    }
    return _cache;
}

- (NSString *)optimizeString:(NSString *)s {
    s = [s rx_stringByReplacingMatchesOfPattern:@"\\(.*\\)" withTemplate:@""];
    s = [s stringByReplacingOccurrencesOfString:@"OST" withString:@""];
    s = [s stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    return s;
}

- (UIImage *)imageFromCacheForKey:(NSString *)key {
    UIImage *cachedImage = [self.cache imageFromMemoryCacheForKey:key];
    if (!cachedImage) {
        cachedImage = [self.cache imageFromDiskCacheForKey:key];
    }
    return cachedImage;
}

- (PMKPromise *)load:(VKAudio *)audio {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        UIImage *cacheImage = [self imageFromCacheForKey:audio.id.stringValue];
        if (cacheImage) {
            fulfill(cacheImage);
        } else {
            NSString *title = [self optimizeString:audio.title];
            NSString *artist = [self optimizeString:audio.artist];
            NSString *searchTerm = [NSString stringWithFormat:@"%@+%@", artist, title];
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/ru/search?term=%@", encodeString(searchTerm)];
            NSLog(@"url: %@",url);
            [NSURLConnection GET:url query:nil].then(^(NSDictionary *searchResponse) {
                return searchResponse[@"results"];
            }).then(^(NSArray *searchResults) {
                return searchResults.firstObject[@"artworkUrl30"];
            }).then(^(NSString* artworkURl30){
                NSString* artworkURL = artworkURl30;
                NSString* artworkURL400 = [artworkURl30 stringByReplacingOccurrencesOfString:@".30x30-50.jpg" withString:@".400x400-75.jpg"];
                if (artworkURL400) {
                    artworkURL = artworkURL400;
                }
                return artworkURL;
            }).then(^(NSString *artworkURL) {
                return [NSURLConnection GET:artworkURL query:nil];
            }).then(^(UIImage *img) {
                if (!img) {
                    img = [UIImage imageNamed:@"AlbumnArtwork"];
                }
                return img;
            }).catch(^(NSException *exception1) {
                // Default image on the
                return [UIImage imageNamed:@"AlbumnArtwork"];
            }).then(^(UIImage *img) {
                [self.cache storeImage:img forKey:audio.id.stringValue];
                fulfill(img);
            });
        }

    }];
}

-(UIImage *)cachedArtwork:(VKAudio *)audio{
    return [self imageFromCacheForKey:audio.id.stringValue];;
}
@end
