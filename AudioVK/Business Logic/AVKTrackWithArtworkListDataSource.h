//
//  AVKTrackWithArtworkListDataSource.h
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKAudioDataSource;
@interface AVKTrackWithArtworkListDataSource : NSObject<UITableViewDataSource>
-(instancetype)initWithAudioDataSource:(VKAudioDataSource*)dataSource;
@end
