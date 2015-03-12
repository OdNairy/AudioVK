//
//  AVKTrackWithArtworkCell.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkCell.h"

@interface AVKTrackWithArtworkCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToDownloadButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingConstraint;
@property (nonatomic, weak) IBOutlet UIView* downloadView;
@end

@implementation AVKTrackWithArtworkCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
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
