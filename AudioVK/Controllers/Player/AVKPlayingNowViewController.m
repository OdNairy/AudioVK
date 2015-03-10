//
//  AVKPlayingNowViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <LMMediaPlayer/LMMediaItem.h>
#import "AVKPlayingNowViewController.h"
#import "AVKControlPanelView.h"
#import "VKAudio+Artwork.h"

@interface AVKPlayingNowViewController ()
@property(nonatomic, weak) IBOutlet AVKControlPanelView *controlPanelView;

@property(nonatomic, assign, getter=isExpanded) BOOL expanded;
@property(nonatomic, strong) MASConstraint *playingBottomTopConstraints;
@property(nonatomic, strong) NSLayoutConstraint *topConstraint;

@end

@implementation AVKPlayingNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.shadowOffset = CGSizeMake(0, 3);
    self.view.layer.shadowOpacity = 0.6;
    self.view.layer.shadowColor = UIColor.blackColor.CGColor;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)configurePlayingNowConstraints {
    UIView *superView = self.view.superview;

    self.topConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                      attribute:(NSLayoutAttributeBottom)
                                                      relatedBy:(NSLayoutRelationEqual)
                                                         toItem:superView
                                                      attribute:(NSLayoutAttributeTop)
                                                     multiplier:1
                                                       constant:300];
    NSLayoutConstraint *width = [NSLayoutConstraint
            constraintWithItem:self.view
                     attribute:NSLayoutAttributeWidth
                     relatedBy:0
                        toItem:superView
                     attribute:NSLayoutAttributeWidth
                    multiplier:1.0
                      constant:0];

    NSLayoutConstraint *height = [NSLayoutConstraint
            constraintWithItem:self.view
                     attribute:NSLayoutAttributeHeight
                     relatedBy:0
                        toItem:superView
                     attribute:NSLayoutAttributeHeight
                    multiplier:1.0
                      constant:0];

    NSLayoutConstraint *top = [NSLayoutConstraint
            constraintWithItem:self.view
                     attribute:NSLayoutAttributeBottom
                     relatedBy:NSLayoutRelationEqual
                        toItem:superView
                     attribute:NSLayoutAttributeTop
                    multiplier:1.0f
                      constant:superView.frame.size.height * 0.2];

    NSLayoutConstraint *leading = [NSLayoutConstraint
            constraintWithItem:self.view
                     attribute:NSLayoutAttributeLeading
                     relatedBy:NSLayoutRelationEqual
                        toItem:superView
                     attribute:NSLayoutAttributeLeading
                    multiplier:1.0f
                      constant:0.f];
    [superView addConstraint:width];
    [superView addConstraint:height];
    [superView addConstraint:top];
    [superView addConstraint:leading];
    self.topConstraint = top;

//    [self.view addConstraint:self.topConstraint];

//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(superView);
//        make.left.equalTo(superView);
//        self.playingBottomTopConstraints =  make.bottom.equalTo(superView.mas_top).with.offset(self.min);
//    }];
}


- (CGFloat)min {
    return self.view.bounds.size.height * 0.2;
}

- (CGFloat)max {
    return self.view.bounds.size.height * 0.985;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self configurePlayingNowConstraints];
}

- (IBAction)showMeButtonTapped:(id)sender {
    self.expanded = !self.expanded;
    if (self.rootDelegate) {
        [self.rootDelegate playingNowVC:self show:self.expanded];
        [self.rootDelegate triggeredPlayingNowVC:self];
    }
    [UIView animateWithDuration:.4 animations:^{
        self.topConstraint.constant = self.expanded ? self.max : self.min;
        [self.view layoutIfNeeded];
    }];
}

- (void)show {
    [UIView animateWithDuration:.4 animations:^{
        self.topConstraint.constant = self.max;
        [self.view layoutIfNeeded];
    }];
}

- (void)close {
    [UIView animateWithDuration:.4 animations:^{
        self.topConstraint.constant = self.min;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)panning:(UIPanGestureRecognizer *)panningGesture {
    CGPoint translation = [panningGesture locationInView:panningGesture.view.window];
    CGFloat offset = MAX(MIN(translation.y, self.max), self.min);
    self.topConstraint.constant = offset;
//    self.playingBottomTopConstraints.with.offset(offset);
//    NSLog(@"%s: %@",__PRETTY_FUNCTION__,NSStringFromCGPoint(translation));
    if (panningGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint finalVelocity = [panningGesture velocityInView:panningGesture.view.window];
        if (finalVelocity.y > 450) {
            [self show];
        } else if (finalVelocity.y < -450) {
            [self close];
        } else {
            CGFloat ratio = offset / self.view.frame.size.height;
            if (ratio < 0.5) {
                [self close];
            } else {
                [self show];
            }
        }
        NSLog(@"ended by velocity: %@", NSStringFromCGPoint(finalVelocity));
    }
}

- (void)updateInfoByAudio:(VKAudio *)audio {
    audio.artwork.then(^(UIImage *artworkImage) {
        self.controlPanelView.artworkImageView.image = artworkImage;
    });
    self.controlPanelView.titleLabel.text = audio.title;
    self.controlPanelView.artistLabel.text = audio.artist;
}

- (void)updateInfoByMediaItem:(LMMediaItem *)mediaItem{
    self.controlPanelView.artworkImageView.image = [mediaItem artworkImageWithSize:self.controlPanelView.artworkImageView.bounds.size];
    self.controlPanelView.titleLabel.text = mediaItem.title;
    self.controlPanelView.artistLabel.text = mediaItem.artist;
}


@end
