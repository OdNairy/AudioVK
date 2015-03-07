//
//  AVKiTunesInfoViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 1/15/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVKiTunesInfoViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView* artworkImageView;
@property (nonatomic, weak) IBOutlet UITextView* textView;
@property (nonatomic, weak) IBOutlet UILabel* searchTermLabel;
@property (nonatomic, strong) VKAudio* audio;
@end
