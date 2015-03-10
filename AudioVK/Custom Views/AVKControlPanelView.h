//
//  AVKControlPanelView.h
//  AudioVK
//
//  Created by Intellectsoft on 08/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVKControlPanelView : UIView
@property(weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *artistLabel;
@property(weak, nonatomic) IBOutlet UILabel *albumnLabel;
@end