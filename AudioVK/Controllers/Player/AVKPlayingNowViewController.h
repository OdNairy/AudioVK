//
//  AVKPlayingNowViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AVKViewController.h"
#import "AVKPlayerProtocol.h"
@class LMMediaItem;

@interface AVKPlayingNowViewController : AVKViewController
@property (nonatomic, weak) id<AVKPlayingNowVCProtocol> rootDelegate;
@property (nonatomic, weak) IBOutlet UIButton* panningView;

- (void)updateInfoByAudio:(VKAudio *)audio;

- (void)updateInfoByMediaItem:(LMMediaItem *)mediaItem;
@end
