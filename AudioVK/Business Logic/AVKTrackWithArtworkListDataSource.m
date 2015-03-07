//
//  AVKTrackWithArtworkListDataSource.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkListDataSource.h"

@interface AVKTrackWithArtworkListDataSource ()
@property (nonatomic, strong) VKAudioDataSource* audioDataSource;
@end

@implementation AVKTrackWithArtworkListDataSource
- (instancetype)initWithAudioDataSource:(VKAudioDataSource *)dataSource
{
    self = [super init];
    if (self) {
        self.audioDataSource = dataSource;
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
