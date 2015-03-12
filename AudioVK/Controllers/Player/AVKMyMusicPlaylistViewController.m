//
//  AVKMyMusicPlaylistViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <LMMediaPlayer/LMMediaItem.h>
#import "AVKMyMusicPlaylistViewController.h"
#import "AVKTrackWithArtworkListDataSource.h"
#import "AVKTrackWithArtworkCell.h"
#import "AVKAudioDataSource.h"
#import "AVKMyMusicVCDelegate.h"
#import "AVKPlaylistPlayer.h"
#import "AVKPlaylistPlayerDelegate.h"

@interface AVKMyMusicPlaylistViewController () <AVKPlaylistPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AVKTrackWithArtworkListDataSource* dataSource;

@property(nonatomic, strong) AVKPlaylistPlayer *playlistPlayer;
@end

@implementation AVKMyMusicPlaylistViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VKAudio *selectedAudio = [self.dataSource audioForIndexPath:indexPath];
    NSArray *audiosStack = [self.dataSource audioStackFromIndex:indexPath.row];

    if ([self.delegate respondsToSelector:@selector(musicPlaylistVC:didSelectAudio:)]) {
        [self.delegate musicPlaylistVC:self didSelectAudio:selectedAudio];
    }
    self.playlistPlayer.queue = audiosStack;
    [self.playlistPlayer play];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* downloadAllItemsButton = [[UIBarButtonItem alloc]initWithTitle:@"Download all" style:(UIBarButtonItemStylePlain) target:self action:@selector(downloadAll)];
    [downloadAllItemsButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = downloadAllItemsButton;

    AVKAudioDataSource* audioDataSource = [[AVKAudioDataSource alloc] initWithUserId:[VKSdk getAccessToken].userId];
    self.dataSource = [[AVKTrackWithArtworkListDataSource alloc] initWithAudioDataSource:audioDataSource];
    self.playlistPlayer = [[AVKPlaylistPlayer alloc] init];
    self.playlistPlayer.delegate = self;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AVKTrackWithArtworkCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([AVKTrackWithArtworkCell class])];
    [[self.dataSource load] continueWithBlock:^id(BFTask *task) {
        [self.tableView reloadData];
        return nil;
    }];
}

- (void)downloadAll{
    
}

-(void)setDataSource:(AVKTrackWithArtworkListDataSource *)dataSource{
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
}

- (void)playlistPlayer:(AVKPlaylistPlayer *)playlistPlayer willPlayItem:(LMMediaItem *)mediaItem{
    if ([self.delegate respondsToSelector:@selector(musicPlaylistVC:willPlayMediaItem:)]) {
        [self.delegate musicPlaylistVC:self willPlayMediaItem:mediaItem];
    }
}


@end
