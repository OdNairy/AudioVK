//
//  AVKPlayerControlProtocel.h
//  AudioVK
//
//  Created by Intellectsoft on 12/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#ifndef AudioVK_AVKPlayerControlProtocol_h
#define AudioVK_AVKPlayerControlProtocol_h

@protocol AVKPlayerControlProtocol <NSObject>

- (void)play;
- (void)pause;
- (void)stop;
- (void)toggle;

- (void)next;
- (void)previous;

@end

#endif
