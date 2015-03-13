//
//  AVKTrackWithArtworkListDataSource.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkListDataSource.h"

#import "AVKTrackWithArtworkCell.h"
#import "AVKAudioDataSource.h"
#import <VKAudio.h>
#import "Promise+Pause.h"
#import "AVKAudioCacheLayer.h"

@interface AVKTrackWithArtworkListDataSource ()
@property (nonatomic, strong) AVKAudioDataSource * audioDataSource;
@end

@implementation AVKTrackWithArtworkListDataSource
- (instancetype)initWithAudioDataSource:(AVKAudioDataSource *)dataSource
{
    self = [super init];
    if (self) {
        self.audioDataSource = dataSource;
        
    }
    return self;
}

-(BFTask*)load{
    return [self.audioDataSource load];
}
-(BFTask*)reload{
    return [self.audioDataSource reload];
}

- (VKAudio *)audioForIndexPath:(NSIndexPath *)indexPath; {
    NSArray *audios = self.audioDataSource.audios;
    if (indexPath.row < audios.count) {
        return audios[indexPath.row];
    }
    return nil;
}

- (NSArray *)audioStackFromIndex:(NSUInteger)startIndex {
    NSArray *audios = self.audioDataSource.audios;
    return [audios subarrayWithRange:NSMakeRange(startIndex, audios.count - startIndex)];
}

-(void)cacheAllAudios{
    for (VKAudio* audio in self.audioDataSource.audios) {
        if (!audio.fromCache) {
            [[AVKAudioCacheLayer instance] cacheAudio:audio
                                          progression:nil
                                           completion:^(VKAudio *audio, BOOL success) {
                                               NSLog(@"Audio %@ did cached",audio.id);
                                           }];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.audioDataSource.audios.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VKAudio* audio = self.audioDataSource.audios[indexPath.row];
    AVKTrackWithArtworkCell* trackCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AVKTrackWithArtworkCell class]) forIndexPath:indexPath];
    [trackCell setupWithAudio:audio];


    return trackCell;
}

@end
