//
// Created by Intellectsoft on 09/03/15.
// Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKAudio.h"
#import <PromiseKit/Promise.h>

@interface VKAudio (Artwork)
- (PMKPromise *)artwork;
- (UIImage*)cachedArtwork;
@end