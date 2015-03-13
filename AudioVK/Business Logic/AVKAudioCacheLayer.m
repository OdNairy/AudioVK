//
//  AVKAudioCacheLayer.m
//  AudioVK
//
//  Created by Intellectsoft on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKAudioCacheLayer.h"

NSString* cacheBaseDirectory(){ return  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]; }
NSString* musicCacheBaseDirectory(){ return [cacheBaseDirectory() stringByAppendingPathComponent:@"music_cache"]; }
NSString* cachePathForAudio(NSNumber* audioId){ return [[musicCacheBaseDirectory() stringByAppendingPathComponent:audioId.stringValue] stringByAppendingPathExtension:@"mp3"]; }

@class AVKAudioDownloader;
typedef void(^AudioCacheInternalProgressionBlock)(AVKAudioDownloader* audioDownloader, long long downloadedBytes, long long totalBytes);
typedef void(^AudioCacheInternalCompletionBlock)(AVKAudioDownloader* audioDownloader);



@interface AVKAudioDownloader : NSObject
@property (nonatomic, strong) VKAudio* audio;
@property (nonatomic, copy) AudioCacheInternalProgressionBlock progressionBlock;
@property (nonatomic, copy) AudioCacheInternalCompletionBlock completionBlock;
- (instancetype)initWithAudio:(VKAudio*)audio progressionBlock:(AudioCacheInternalProgressionBlock)progressionBlock completion:(AudioCacheInternalCompletionBlock)completionBlock;

- (void)start;

@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSMutableData* audioData;
@property (nonatomic, strong) NSHTTPURLResponse* response;
@property (nonatomic, strong) NSError* completionError;
@end


@interface AVKAudioCacheLayer ()
@property (nonatomic, strong) NSMutableDictionary* audioDownloadersStorage;
@end

@implementation AVKAudioCacheLayer
+ (instancetype)instance{
    static dispatch_once_t onceToken;
    static AVKAudioCacheLayer* cacheLayer;
    dispatch_once(&onceToken, ^{
        cacheLayer = [[AVKAudioCacheLayer alloc] init];
        @synchronized(cacheLayer){
            if (![[NSFileManager defaultManager] fileExistsAtPath:musicCacheBaseDirectory()]) {
                NSError*  musicCacheDirectoryCreateError;
                BOOL musicCacheDirectoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:musicCacheBaseDirectory() withIntermediateDirectories:YES attributes:nil error:&musicCacheDirectoryCreateError];
                if (!musicCacheDirectoryCreated) {
                    NSLog(@"Failed to create music cache directory with an error: %@",musicCacheDirectoryCreateError);
                }
            }
        }
    });
    return cacheLayer;
}

- (BOOL)isAudioCachedForId:(NSNumber*)audioId{
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForAudio(audioId)];
}

- (BOOL)isAudioCachingRightNow:(NSNumber*)audioId{
    return self.audioDownloadersStorage[audioId] != nil;
}

- (BOOL)isAudioCachedOrCaching:(NSNumber*)audioId{
    return [self isAudioCachedForId:audioId] || [self isAudioCachingRightNow:audioId];
}

- (NSURL*)resourceURLForCachedAudioId:(NSNumber*)audioId{
    return [NSURL fileURLWithPath:cachePathForAudio(audioId)];
}

#pragma mark - Audio Downloader Manager
-(NSMutableDictionary *)audioDownloadersStorage{
    if (!_audioDownloadersStorage) {
        _audioDownloadersStorage = [NSMutableDictionary dictionary];
    }
    return _audioDownloadersStorage;
}

- (void)addAudioDownloader:(AVKAudioDownloader*)audioDownloader{
    [audioDownloader start];
    self.audioDownloadersStorage[audioDownloader.audio.id] = audioDownloader;
}

- (void)removeAudioDownloader:(AVKAudioDownloader*)audioDownloader{
    [self.audioDownloadersStorage removeObjectForKey:audioDownloader.audio.id];
}

#pragma mark - Audio Downloader
- (void)cacheAudio:(VKAudio*)audio progression:(AudioCacheProgressionBlock)progressionBlock completion:(AudioCacheCompletionBlock)completionBlock{
    __weak __typeof(self) weakSelf = self;
    
    AVKAudioDownloader* downloader = [[AVKAudioDownloader alloc] initWithAudio:audio
                                                                progressionBlock:^(AVKAudioDownloader *audioDownloader, long long downloadedBytes, long long totalBytes) {
                                                                    if (progressionBlock) {
                                                                        progressionBlock(audioDownloader.audio,downloadedBytes,totalBytes);
                                                                    }
                                                                } completion:^(AVKAudioDownloader *audioDownloader) {
                                                                    __strong typeof(weakSelf) self = weakSelf;
                                                                    VKAudio* audio = audioDownloader.audio;
                                                                    [self removeAudioDownloader:audioDownloader];
                                                                    [self cacheAudioId:audio.id audioData:audioDownloader.audioData];
                                                                    completionBlock(audio, audioDownloader.completionError == nil);
                                                                }];
    [self addAudioDownloader:downloader];}

#pragma mark - Audio Data FileSystem 

- (void)cacheAudioId:(NSNumber*)audioId audioData:(NSData*)audioData{
    NSAssert(![self isAudioCachedForId:audioId], @"Audio data has been cached for audioId: %@ till another AudioDownloader has beed worked",audioId);
    
    [[NSFileManager defaultManager] createFileAtPath:cachePathForAudio(audioId) contents:audioData attributes:@{NSFileCreationDate:[NSDate date]}];
}
@end


@interface AVKAudioDownloader ()<NSURLConnectionDataDelegate> @end
@implementation AVKAudioDownloader
- (instancetype)initWithAudio:(VKAudio*)audio progressionBlock:(AudioCacheInternalProgressionBlock)progressionBlock completion:(AudioCacheInternalCompletionBlock)completionBlock{
    self = [super init];
    if (self) {
        NSAssert(completionBlock, @"Completion block cannot be nil");
        self.audio = audio;
        self.progressionBlock = progressionBlock;
        self.completionBlock = completionBlock;
        
        NSURLRequest* audioRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.audio.url] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:60];
        self.connection = [[NSURLConnection alloc] initWithRequest:audioRequest delegate:self];
    }
    return self;
}
-(void)start{
    [self.connection start];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.audioData = [NSMutableData data];
    self.response = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.audioData appendData:data];
    if (self.progressionBlock) {
        self.progressionBlock(self,self.audioData.length, self.response.expectedContentLength);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.completionBlock(self);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.completionError = error;
    self.completionBlock(self);
}

@end
