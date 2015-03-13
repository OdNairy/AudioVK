//
//  AVKTrackOptionsView.h
//  AudioVK
//
//  Created by Intellectsoft on 13/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVKTrackOptionsView : UIView
@property (nonatomic, getter=isDownloadButtonActive) BOOL downloadButtonActive;
@property (nonatomic, strong) VKAudio* audio;
@end
