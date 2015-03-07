//
//  AVKStorage.h
//  AudioVK
//
//  Created by Roman Gardukevich on 05.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "VKApiObject.h"
#import <Bolts.h>

extern NSString *const AVKSessionTokenStorageKey;

@interface AVKStorage : VKApiObject
+ (instancetype)sharedStorage;

- (BFTask*)valueForKey:(NSString *)key;
- (BFTask*)valueForUndefinedKey:(NSString *)key;

- (BFTask*)setValue:(id)value forKey:(NSString *)key;
- (BFTask*)setValue:(id)value forUndefinedKey:(NSString *)key;

- (BFTask*)setNilValueForKey:(NSString *)key;
@end
