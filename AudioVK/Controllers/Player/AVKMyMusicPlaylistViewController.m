//
//  AVKMyMusicPlaylistViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKMyMusicPlaylistViewController.h"
#import "AVKTrackWithArtworkListDataSource.h"
#import "AVKAudioDataSource.h"

@interface AVKMyMusicPlaylistViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AVKTrackWithArtworkListDataSource* dataSource;
@end

@implementation AVKMyMusicPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVKAudioDataSource* audioDataSource = [[AVKAudioDataSource alloc] initWithUserId:[VKSdk getAccessToken].userId];
    self.dataSource = [[AVKTrackWithArtworkListDataSource alloc] initWithAudioDataSource:audioDataSource];
    
    [[self.dataSource load] continueWithBlock:^id(BFTask *task) {
        [self.tableView reloadData];
        return nil;
    }];
}

-(void)setDataSource:(AVKTrackWithArtworkListDataSource *)dataSource{
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
}



@end
