//
//  AVKArtworkLoader.m
//  AudioVK
//
//  Created by Roman Gardukevich on 07/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKArtworkLoader.h"
#import <Regexer.h>

@interface AVKArtworkLoader ()
@property (nonatomic, strong) NSMutableDictionary* cache;
@end

@implementation AVKArtworkLoader
NSString *encodeString(NSString *string)
{
    static CFStringRef charset = CFSTR("!@#$%&*()'\";:=,/?[]");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

+(instancetype)instance{
    static dispatch_once_t onceToken;
    static AVKArtworkLoader* loader;
    dispatch_once(&onceToken, ^{
        loader = [[AVKArtworkLoader alloc] init];
    });
    return loader;
}

-(NSMutableDictionary *)cache{
    if (!_cache) {
        _cache = [NSMutableDictionary dictionary];
    }
    return _cache;
}

- (void)cacheObject:(UIImage*)artworkImage url:(NSString*)key{
    [self.cache setValue:artworkImage forKey:key];
}

- (NSString*)optimizeString:(NSString*)s{
    s = [s rx_stringByReplacingMatchesOfPattern:@"\\(.*\\)" withTemplate:@""];
    s = [s stringByReplacingOccurrencesOfString:@"OST" withString:@""];
    s = [s stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    return s;
}


- (BFTask*)load:(VKAudio *)audio{
    return [BFTask taskFromExecutor:([BFExecutor executorWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)]) withBlock:^id{
        NSString* title = [self optimizeString:audio.title];
        NSString* artist = [self optimizeString:audio.artist];
        NSString* searchTerm = [NSString stringWithFormat:@"%@+%@",artist,title];
        
        NSString* url = [NSString stringWithFormat:@"https://itunes.apple.com/ru/search?term=%@",encodeString(searchTerm)];
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:nil error:nil];
        NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString* artworkURL = [(NSArray*)resp[@"results"] firstObject][@"artworkUrl30"];
        if (artworkURL) {
            
            artworkURL = [artworkURL stringByReplacingOccurrencesOfString:@".30x30-50.jpg" withString:@".400x400-75.jpg"];
            if (self.cache[audio.id.stringValue]) {
                return self.cache[audio.id.stringValue];
            }
            NSLog(@"artwork url: %@",artworkURL);
            NSData* artworkData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:artworkURL]] returningResponse:nil error:nil];
            UIImage* img =  [UIImage imageWithData:artworkData];;
            [self cacheObject:img url:audio.id.stringValue];
            return img;
        }

        return nil;
    }];
}
@end
