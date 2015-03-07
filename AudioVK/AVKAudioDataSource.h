//
//  AVKAudioDataSource.h
//  AudioVK
//
//  Created by Intellectsoft on 03/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BFTask.h>

@interface AVKAudioDataSource : NSObject
@property (nonatomic, readonly) NSArray* audios;

@property (nonatomic, readonly) NSUInteger totalCount;
@property (nonatomic, readonly) NSUInteger pageCount;
@property (nonatomic, readonly) NSUInteger audiosPerPage;
/* Check @param initialLoaded first get @param audios. If @param initalLoaded equals NO call @method load
 */
@property (nonatomic, readonly, getter=isInitialLoaded) BOOL initialLoaded;


-(instancetype)initWithUserId:(NSString*)userId;

-(BFTask*)load;
-(BFTask*)reload;

@end
