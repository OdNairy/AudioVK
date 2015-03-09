//
//  AVKArtworkLoader.h
//  AudioVK
//
//  Created by Roman Gardukevich on 07/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@interface AVKArtworkLoader : NSObject
+(instancetype)instance;

- (PMKPromise *)load:(VKAudio *)audio;
@end
