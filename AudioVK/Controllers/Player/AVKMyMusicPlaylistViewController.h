//
//  AVKMyMusicPlaylistViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKPlaylistViewController.h"

@protocol AVKMyMusicVCDelegate;

@interface AVKMyMusicPlaylistViewController : AVKPlaylistViewController <UITableViewDelegate>
@property(nonatomic, assign) id <AVKMyMusicVCDelegate> delegate;
@end
