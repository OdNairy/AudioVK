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

@interface AVKPlayingNowViewController : AVKViewController
@property (nonatomic, weak) id<AVKPlayingNowVCProtocol> rootDelegate;
@property (nonatomic, weak) IBOutlet UIButton* panningView;

@end
