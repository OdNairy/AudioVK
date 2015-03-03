//
//  AVKPlayerProtocol.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/24/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#ifndef AudioVK_AVKPlayerProtocol_h
#define AudioVK_AVKPlayerProtocol_h

@class AVKPlayingNowViewController;
@protocol AVKPlayingNowVCProtocol <NSObject>
- (void)playingNowVC:(AVKPlayingNowViewController*)playingNowVC show:(BOOL)show;
- (void)triggeredPlayingNowVC:(AVKPlayingNowViewController*)playingNowVC;

@end

#endif
