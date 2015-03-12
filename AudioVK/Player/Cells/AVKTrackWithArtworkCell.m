//
//  AVKTrackWithArtworkCell.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkCell.h"
#import <MarqueeLabel.h>

@interface AVKTrackWithArtworkCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToDownloadButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingConstraint;
@property (nonatomic, weak) IBOutlet UIView* downloadView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleMarqueeLabel;
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

-(void)setDownloadButtonActive:(BOOL)downloadButtonActive{
    _downloadButtonActive = downloadButtonActive;
    [self.titleToDownloadButtonConstraint setActive:_downloadButtonActive];
    [self.titleTrailingConstraint setActive:!_downloadButtonActive];
    self.downloadView.hidden = !downloadButtonActive;
}

@end
