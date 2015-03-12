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
#import <MediaPlayer/MediaPlayer.h>



@interface AVKMyMusicPlaylistViewController () <AVKPlaylistPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AVKTrackWithArtworkListDataSource* dataSource;

@property(nonatomic, strong) AVKPlaylistPlayer *playlistPlayer;
@end

@implementation AVKMyMusicPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* downloadAllItemsButton = [[UIBarButtonItem alloc]initWithTitle:@"Download all" style:(UIBarButtonItemStylePlain) target:self action:@selector(downloadAll)];
    [downloadAllItemsButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:(UIControlStateNormal)];
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
    
}

-(void)setDataSource:(AVKTrackWithArtworkListDataSource *)dataSource{
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VKAudio *selectedAudio = [self.dataSource audioForIndexPath:indexPath];
    NSArray *audiosStack = [self.dataSource audioStackFromIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(musicPlaylistVC:didSelectAudio:)]) {
        [self.delegate musicPlaylistVC:self didSelectAudio:selectedAudio];
    }
    self.playlistPlayer.queue = audiosStack;
    [self.playlistPlayer play];
    
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
