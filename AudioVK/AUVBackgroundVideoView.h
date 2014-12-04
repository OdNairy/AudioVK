//
//  AUVBackgroundVideoView.h
//  AudioVK
//
//  Created by Roman Gardukevich on 02.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUVBackgroundVideoView : UIView
-(void)playVideoByPath:(NSString*)filePath inLoop:(BOOL)inLoop;
- (void)pause;
- (void)play;
@end
