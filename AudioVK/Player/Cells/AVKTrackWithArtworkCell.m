//
//  AVKTrackWithArtworkCell.m
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKTrackWithArtworkCell.h"

@implementation AVKTrackWithArtworkCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
