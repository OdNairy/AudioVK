//
//  AVKNowPlayingIndicatiorView.m
//  AudioVK
//
//  Created by odnairy on 22/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKNowPlayingIndicatiorView.h"
#import <UIImage+AverageColor.h>
#import "AVKPlaylistPlayer.h"

UIColor* basicIndicatorColor(){
    return [UIColor colorWithRed:102.0/255 green:255.0/255 blue:102.0/255 alpha:1];
}

UIColor* waitingIndicatorSupportColor(){
    return [UIColor whiteColor];
}

@interface AVKNowPlayingIndicatiorView ()
@property (nonatomic, assign,getter=isWaitingForPlaying) BOOL waitForPlaying;  // not playing state, e.g. pause, stop.
@end

NSString* const kWaitingAnimationKey = @"kWaitingAnimationKey";

@implementation AVKNowPlayingIndicatiorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib{
    [self initialize];
}

-(void)initialize{
    [[AVKPlaylistPlayer instance] addTarget:self action:@selector(playingStateHasBeenChanged:) forControlEvents:(AVKPlaylistPlayerWillChangeStateEvent)];

    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(2.0, 6.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)playingStateHasBeenChanged:(NSDictionary*)params{
    AVKMediaPlaybackState state = [params[kAVKPlaylistPlayerStateKey] integerValue];
    self.waitForPlaying = state != AVKMediaPlaybackStatePlaying;
}

-(void)setWaitForPlaying:(BOOL)waitForPlaying{
    _waitForPlaying = waitForPlaying;
    if (waitForPlaying) {
        CAAnimation* waitingAnimation = [self waitingAnimation];
        [self.layer addAnimation:waitingAnimation forKey:kWaitingAnimationKey];
    }else {
        [self completeWaitingAnimation];
    }
}

- (void)completeWaitingAnimation{
    // TODO: complete current animation to basic color
    [self.layer removeAnimationForKey:kWaitingAnimationKey];
    
    [UIView animateWithDuration:.4 animations:^{
        self.backgroundColor = basicIndicatorColor();
    }];
}

-(CABasicAnimation*)waitingAnimation{
    CABasicAnimation* colorChangingAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorChangingAnimation.fromValue = (id)basicIndicatorColor().CGColor;
    colorChangingAnimation.toValue = (id)waitingIndicatorSupportColor().CGColor;
    colorChangingAnimation.duration = 1;
    colorChangingAnimation.autoreverses = YES;
    colorChangingAnimation.repeatCount = HUGE_VALF;
    
    return colorChangingAnimation;
}

@end
