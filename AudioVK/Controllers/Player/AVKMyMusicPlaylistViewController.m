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
#import <AVFoundation/AVFoundation.h>
#import "AVKAudioCacheLayer.h"
#import <MediaPlayer/MediaPlayer.h>


@interface AVKMyMusicPlaylistViewController () <AVKPlaylistPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AVKTrackWithArtworkListDataSource* dataSource;

@property(nonatomic, strong) AVKPlaylistPlayer *playlistPlayer;

@property (nonatomic, strong) UIView* selectedCellIndicator;
@end

@implementation AVKMyMusicPlaylistViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect selectedRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect indicatorFrame = CGRectMake(selectedRect.origin.x, selectedRect.origin.y, self.selectedCellIndicator.bounds.size.width, selectedRect.size.height);
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        self.selectedCellIndicator.frame = indicatorFrame;
        self.selectedCellIndicator.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    VKAudio *selectedAudio = [self.dataSource audioForIndexPath:indexPath];
    NSArray *audiosStack = [self.dataSource audioStackFromIndex:indexPath.row];

    if ([self.delegate respondsToSelector:@selector(musicPlaylistVC:didSelectAudio:)]) {
        [self.delegate musicPlaylistVC:self didSelectAudio:selectedAudio];
    }
    self.playlistPlayer.queue = audiosStack;

    // push play block after current RunLoop
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playlistPlayer play];
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedCellIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.tableView.rowHeight)];
    self.selectedCellIndicator.backgroundColor = [UIColor colorWithRed:102./255 green:1 blue:102./255 alpha:1];
    self.selectedCellIndicator.alpha = 0;
    [self.tableView addSubview:self.selectedCellIndicator];
    
    UIBarButtonItem* downloadAllItemsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download_button"] style:(UIBarButtonItemStylePlain) target:self action:@selector(downloadAll)];
    downloadAllItemsButton.tintColor = [UIColor whiteColor];
    [downloadAllItemsButton setBackgroundVerticalPositionAdjustment:4 forBarMetrics:(UIBarMetricsDefault)];
//    [downloadAllItemsButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = downloadAllItemsButton;

    AVKAudioDataSource* audioDataSource = [[AVKAudioDataSource alloc] initWithUserId:[VKSdk getAccessToken].userId];
    self.dataSource = [[AVKTrackWithArtworkListDataSource alloc] initWithAudioDataSource:audioDataSource];
    self.playlistPlayer = [AVKPlaylistPlayer instance];
    self.playlistPlayer.delegate = self;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AVKTrackWithArtworkCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([AVKTrackWithArtworkCell class])];
    [[self.dataSource load] continueWithBlock:^id(BFTask *task) {
        [self.tableView reloadData];
        return nil;
    }];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self setupRemoteEventHandlers];
}

-(void)setupRemoteEventHandlers{
    MPRemoteCommandCenter* center = [MPRemoteCommandCenter sharedCommandCenter];
    [center.pauseCommand addTarget:self.playlistPlayer action:@selector(pause)];
    [center.playCommand addTarget:self.playlistPlayer action:@selector(play)];
//    [center.stopCommand addTarget:self.playlistPlayer action:@selector(stop)];
    [center.togglePlayPauseCommand addTarget:self.playlistPlayer action:@selector(toggle)];
    
    [center.nextTrackCommand addTarget:self.playlistPlayer action:@selector(next)];
    [center.previousTrackCommand addTarget:self.playlistPlayer action:@selector(previous)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)downloadAll{
    [self.dataSource cacheAllAudios];
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


#pragma mark - 

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.playlistPlayer play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.playlistPlayer pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.playlistPlayer toggle];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.playlistPlayer next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.playlistPlayer previous];
                break;
            default:
                break;
        }
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            //            [self playAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            //            [self pauseAudio];
            
//            self.audioPlayer.rate = 0;
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            //            [self togglePlayPause];
            
        }
    }
}

@end
