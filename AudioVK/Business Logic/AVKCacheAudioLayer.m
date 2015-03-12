//
//  AVKCacheAudioLayer.m
//  TEST
//
//  Created by Roman Gardukevich on 11/03/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKCacheAudioLayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSString* const kAVKCacheAudioLayerCustomScheme = @"kAVKCacheAudioLayerCustomScheme";

@interface AVKCacheAudioLayer ()<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURL* audioURL;
@property (nonatomic, copy) NSString* originalAudioUrlScheme;

@property (nonatomic, strong) NSURL* cacheURL;

@property (nonatomic, strong) NSMutableData *songData;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableArray *pendingRequests;
@end

@implementation AVKCacheAudioLayer
- (instancetype)initWithAudioURL:(NSURL *)audioURL cachePath:(NSURL *)cacheURL
{
    self = [super init];
    if (self) {
        self.audioURL = audioURL;
        self.originalAudioUrlScheme = [self schemeFromUrl:audioURL];
        self.cacheURL = cacheURL;
        
        
        self.pendingRequests = [NSMutableArray array];
    }
    return self;
}

-(NSURL *)processedAudioURL{
    return [self songURLWithCustomScheme:kAVKCacheAudioLayerCustomScheme url:self.audioURL];
}

#pragma mark - NSURL processing
- (NSURL *)songURLWithCustomScheme:(NSString *)scheme url:(NSURL*)url
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    
    return [components URL];
}

- (NSString*)schemeFromUrl:(NSURL*)url{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    return components.scheme;
}


-(void)cancel{
    [self.connection cancel];
}

#pragma mark - AVAssetResourceLoader Delegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    if (self.connection == nil)
    {
        NSURL *interceptedURL = [loadingRequest.request URL];
        NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:interceptedURL resolvingAgainstBaseURL:NO];
        actualURLComponents.scheme = self.originalAudioUrlScheme;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[actualURLComponents URL]];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
        
        [self.connection start];
    }
    
    NSLog(@"requestResource: requestedLength: %zd, requestedOffset: %lld, currentOffset: %lld",loadingRequest.dataRequest.requestedLength,loadingRequest.dataRequest.requestedOffset,loadingRequest.dataRequest.currentOffset);
    [self.pendingRequests addObject:loadingRequest];
    
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self.pendingRequests removeObject:loadingRequest];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.songData = [NSMutableData data];
    self.response = (NSHTTPURLResponse *)response;
    
    [self processPendingRequests];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.songData appendData:data];
    
    [self processPendingRequests];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self processPendingRequests];
    
    if ([self.delegate respondsToSelector:@selector(cacheAudioLayer:didFinishLoadingData:)]) {
        [self.delegate cacheAudioLayer:self didFinishLoadingData:self.songData];
    }
    
    [self.songData writeToURL:self.cacheURL atomically:YES];
}

#pragma mark - AVURLAsset process requests
- (void)processPendingRequests
{
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
    {
        [self fillInContentInformation:loadingRequest.contentInformationRequest];
        
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest];
        
        if (didRespondCompletely)
        {
            [requestsCompleted addObject:loadingRequest];
            
            [loadingRequest finishLoading];
        }
    }
    
    [self.pendingRequests removeObjectsInArray:requestsCompleted];
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (contentInformationRequest == nil || self.response == nil)
    {
        return;
    }
    
    NSString *mimeType = [self.response MIMEType];
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    contentInformationRequest.contentLength = [self.response expectedContentLength];
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    long long startOffset = dataRequest.requestedOffset;
    if (dataRequest.currentOffset != 0)
    {
        startOffset = dataRequest.currentOffset;
    }
    
    // Don't have any data at all for this request
    if (self.songData.length < startOffset)
    {
        return NO;
    }
    
    // This is the total data we have from startOffset to whatever has been downloaded so far
    NSUInteger unreadBytes = self.songData.length - (NSUInteger)startOffset;
    
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    
    [dataRequest respondWithData:[self.songData subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWith)]];
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = self.songData.length >= endOffset;
    
    return didRespondFully;
}

@end
