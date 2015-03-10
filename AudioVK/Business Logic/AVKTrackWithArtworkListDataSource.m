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
#import "AVKArtworkLoader.h"
#import "AudioVK-Swift.h"
#import "Promise+Pause.h"

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.audioDataSource.audios.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VKAudio* audio = self.audioDataSource.audios[indexPath.row];
    AVKTrackWithArtworkCell* trackCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AVKTrackWithArtworkCell class]) forIndexPath:indexPath];
    trackCell.titleLabel.text = audio.title;
    trackCell.artistLabel.text = audio.artist;
    trackCell.albumnLabel.text = [AVKAudioGenre genreStringFrom:audio.genre_id];
    trackCell.artworkImageView.image = [UIImage imageNamed:@"AlbumnArtwork"];

    [[AVKArtworkLoader instance] load:audio].then(^(UIImage *img) {
        if ([trackCell.titleLabel.text isEqualToString:audio.title] && img) {
            trackCell.artworkImageView.image = img;
        }
    });

    return trackCell;
}

@end
