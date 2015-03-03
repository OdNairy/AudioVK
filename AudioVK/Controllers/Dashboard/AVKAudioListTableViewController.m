//
//  AVKAudioListTableViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 12/13/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKAudioListTableViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "iTunesInfoViewController.h"

@interface AVKAudioListTableViewController ()
@property (nonatomic, strong) NSArray* audios;
@property (nonatomic, strong) AVQueuePlayer* audioPlayer;

@end

@implementation AVKAudioListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    [self.refreshControl addTarget:self action:@selector(pullToRefreshAction) forControlEvents:(UIControlEventValueChanged)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self loadTracks];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)loadTracks{
    VKRequest* req = [VKRequest requestWithMethod:@"audio.get" andParameters:@{@"owner_id":VKSdk.getAccessToken.userId} andHttpMethod:@"GET" classOfModel:[VKAudios class]];
    [req setCompleteBlock:^(VKResponse *resp) {
        self.audios = [(VKAudios*)resp.parsedModel items];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    [req start];
}

- (void)pullToRefreshAction{
    [self loadTracks];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.audios.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.audios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    VKAudio* audio = self.audios[indexPath.row];
    
    cell.textLabel.text = audio.title;
    cell.detailTextLabel.text = audio.artist;
    
    
    return cell;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.audioPlayer play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.audioPlayer pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (self.audioPlayer.rate) {
                    [self.audioPlayer play];
                }else {
                    [self.audioPlayer pause];
                }
                break;
                case UIEventSubtypeRemoteControlNextTrack:
                [self.audioPlayer advanceToNextItem];
                break;
                
            default:
                break;
        }
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
//            [self playAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
//            [self pauseAudio];
            self.audioPlayer.rate = 0;
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
//            [self togglePlayPause];
            
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VKAudio* audio = self.audios[indexPath.row];
    iTunesInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"iTunesInfoViewController"];
    vc.audio = audio;
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
    
    if (self.audioPlayer.rate > 0) {
        self.audioPlayer.rate = 0;
    } else {
        NSMutableArray* itemsQueue = [NSMutableArray array];
        for (NSInteger i = indexPath.row; i< self.audios.count; i++) {
            VKAudio* audio = self.audios[i];
            NSURL* audioURL = [NSURL URLWithString:audio.url];
//            NSLog(@"Add audio URL: %@",audioURL);
            AVPlayerItem* item = [AVPlayerItem playerItemWithURL:audioURL];
            
            [itemsQueue addObject:item];
        }
        
        VKAudio* audio = self.audios[indexPath.row];
        
        NSError* error;
        [self.audioPlayer removeObserver:self forKeyPath:@"status"];
        self.audioPlayer = [AVQueuePlayer queuePlayerWithItems:itemsQueue];
        [self.audioPlayer addObserver:self forKeyPath:@"status"
                              options:0
                              context:nil];
        if (error) {
            NSLog(@"Error: %@",error);
        }
        [self.audioPlayer play];

        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:audio.url ] options:nil];
        // get the duration of sound to be played in seconds
        CMTime audioDuration = audioAsset.duration;
        
//        Float64 duration = CMTimeGetSeconds(self.audioPlayer.currentItem.duration);
        
        MPNowPlayingInfoCenter* infoCenter = [MPNowPlayingInfoCenter defaultCenter];
        infoCenter.nowPlayingInfo = @{MPMediaItemPropertyArtist: audio.artist, MPMediaItemPropertyTitle: audio.title, MPMediaItemPropertyPlaybackDuration:audio.duration,MPMediaItemPropertyLyrics:@"It's my lyrics."};
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        MPNowPlayingInfoCenter* infoCenter = [MPNowPlayingInfoCenter defaultCenter];
        NSMutableDictionary* info = [infoCenter.nowPlayingInfo mutableCopy];
        info[MPMediaItemPropertyPlaybackDuration] = @(CMTimeGetSeconds(self.audioPlayer.currentItem.duration));
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
