//
//  AVKStorage.m
//  AudioVK
//
//  Created by Roman Gardukevich on 05.12.14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKStorage.h"

NSString *const AVKSessionTokenStorageKey = @"AudioVKSessionToken";


@implementation AVKStorage
+(instancetype)sharedStorage{
    static dispatch_once_t onceToken;
    static AVKStorage * storage;
    dispatch_once(&onceToken, ^{
        storage = [[AVKStorage alloc] init];
    });
    return storage;
}

-(BFTask *)valueForKey:(NSString *)key{
    return [super valueForKey:key];
}

-(BFTask *)setValue:(id)value forKey:(NSString *)key{
    return [self setValue:value forUndefinedKey:key];
}

- (BFTask*)valueForUndefinedKey:(NSString *)key{
    BFTaskCompletionSource* task = [BFTaskCompletionSource taskCompletionSource];
    VKRequest* req = [VKRequest requestWithMethod:@"storage.get" andParameters:@{@"key":key} andHttpMethod:@"GET"];
    [req setCompleteBlock:^(VKResponse *response) {
        [task setResult:response.json];
    }];
    [req start];
    return task.task;
}

- (BFTask*)setValue:(id)value forUndefinedKey:(NSString *)key{
    BFTaskCompletionSource* task = [BFTaskCompletionSource taskCompletionSource];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{@"key":key}];
    if (value) [params setValue:value forKey:@"value"];
    VKRequest* req = [VKRequest requestWithMethod:@"storage.set" andParameters:params andHttpMethod:@"GET"];
    [req setCompleteBlock:^(VKResponse *response) {
        [task setResult:response.json];
    }];
    [req start];
    return task.task;
}

- (BFTask*)setNilValueForKey:(NSString *)key{
    return [self setValue:nil forUndefinedKey:key];
}
@end
