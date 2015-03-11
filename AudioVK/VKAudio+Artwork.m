//
// Created by Intellectsoft on 09/03/15.
// Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "VKAudio+Artwork.h"
#import "AVKArtworkLoader.h"


@implementation VKAudio (Artwork)
- (PMKPromise *)artwork {
    return [[AVKArtworkLoader instance] load:self];
}

-(UIImage *)cachedArtwork{
    return [[AVKArtworkLoader instance] cachedArtwork:self];
}

@end