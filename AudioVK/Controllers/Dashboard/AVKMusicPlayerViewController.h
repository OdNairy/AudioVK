//
//  AVKMusicPlayerViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/3/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVKMusicPlayerViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel* nowPlayingTitleLabel;
@property (nonatomic, weak) IBOutlet UISlider* slider;
@end
