//
//  AVKTrackWithArtworkCell.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkCell.h"
#import <MarqueeLabel.h>
#import "AVKTrackOptionsView.h"
#import "AVKArtworkLoader.h"
#import "AudioVK-Swift.h"
#import <PromiseKit.h>

@interface AVKTrackWithArtworkCell ()
@property (nonatomic, weak) IBOutlet AVKTrackOptionsView* downloadView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleMarqueeLabel;

@property (nonatomic, strong) VKAudio* audio;
@end

@implementation AVKTrackWithArtworkCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    self.titleMarqueeLabel.scrollDuration = 30;
    self.titleMarqueeLabel.marqueeType = MLLeftRight;
//    self.titleMarqueeLabel.scrollDuration = 15.0;
    self.titleMarqueeLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    self.titleMarqueeLabel.fadeLength = 10.0f;
    self.titleMarqueeLabel.leadingBuffer = 0;
    self.titleMarqueeLabel.trailingBuffer = 0;
    self.titleMarqueeLabel.tag = 101;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
}

-(void)setupWithAudio:(VKAudio *)audio{
    self.downloadView.audio = audio;
    self.audio = audio;

    self.titleLabel.text = audio.title;
    self.artistLabel.text = audio.artist;
    self.albumnLabel.text = [AVKAudioGenre genreStringFrom:audio.genre_id];
    self.artworkImageView.image = [UIImage imageNamed:@"AlbumnArtwork"];
    
    [[AVKArtworkLoader instance] load:audio].then(^(UIImage *img) {
        if ([self.audio.id isEqualToNumber:audio.id] && img) {
            self.artworkImageView.image = img;
        }
    });
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    UIColor *selectedColor = [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1];
    UIColor *defaultColor = [UIColor colorWithRed:53.0/255 green:53.0/255 blue:53.0/255 alpha:1];
    [UIView promiseWithDuration:.2 animations:^{
        self.backgroundColor = selected? selectedColor: defaultColor;
    }];
    if (selected) {
        [self.titleMarqueeLabel unpauseLabel];
    }else {
        [self.titleMarqueeLabel resetLabel];
        [self.titleMarqueeLabel pauseLabel];
    }
}

@end
