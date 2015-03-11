//
//  AVKAudioDataSource.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKAudioDataSource.h"
#import "AVKAudioCacheLayer.h"

#import <BFExecutor.h>


const NSUInteger maxAudiosPerPage = 500;

@interface AVKAudioDataSource ()
@property (nonatomic, strong) NSArray* audios;
@property (nonatomic, strong) VKRequest* initialRequest;

@property (nonatomic) NSUInteger totalCount;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic) NSUInteger audiosPerPage;
@property (nonatomic, getter=isInitialLoaded) BOOL initialLoaded;
@end

@implementation AVKAudioDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.audiosPerPage = maxAudiosPerPage;
    }
    return self;
}
- (instancetype)initWithUserId:(NSString *)userId
{
    self = [self init];
    if (self) {
        self.initialRequest = [VKRequest requestWithMethod:@"audio.get" andParameters:@{@"owner_id": userId} andHttpMethod:@"GET" classOfModel:[VKAudios class]];
    }
    return self;
}

-(BFTask *)load{
    __weak __typeof(self) weakSelf = self;
    BFExecutor* requestCompletedExecutor = [BFExecutor executorWithBlock:^(void(^block)()){
        VKRequest* request = weakSelf.initialRequest;
        
        [request setCompleteBlock:^(VKResponse *response) {
            weakSelf.initialLoaded = YES;
            [weakSelf parseResponse:response];
            block();
        }];
        [request start];
    }];
    
    return [BFTask taskFromExecutor:requestCompletedExecutor
                          withBlock:^id{
                              return self;
                          }];
}

-(BFTask *)reload{
    self.totalCount = 0;
    self.pageCount = 0;
    self.initialLoaded = NO;
    
    return [self load];
}


-(void)parseResponse:(VKResponse*)response{
    VKAudios *vkAudios = response.parsedModel;
    self.audios = vkAudios.items;
    for (VKAudio* audio in self.audios) {
        audio.fromCache = [AVKAudioCacheLayer.instance isAudioCachedForId:audio.id];
    }

    self.totalCount = self.audios.count;
    self.pageCount = ceil( (float)self.totalCount /self.audiosPerPage);
}

@end