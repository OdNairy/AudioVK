//
//  iTunesInfoViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/15/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "iTunesInfoViewController.h"
#import <Regexer.h>

NSString *encode(NSString *string)
{
    static CFStringRef charset = CFSTR("!@#$%&*()'\";:=,/?[]");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@interface iTunesInfoViewController ()

@end

@implementation iTunesInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateAudioData];
    // Do any additional setup after loading the view.
}

-(void)setAudio:(VKAudio *)audio{
    _audio = audio;
    if ([self isViewLoaded]) {
        [self updateAudioData];
    }
}

-(void)updateAudioData{
    if (!_audio) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString* title = [self optimizeString:_audio.title];
        NSString* artist = [self optimizeString:_audio.artist];
        NSString* searchTerm = [NSString stringWithFormat:@"%@+%@",artist,title];
        self.searchTermLabel.text = searchTerm;
        
        NSString* url = [NSString stringWithFormat:@"https://itunes.apple.com/ru/search?term=%@",encode(searchTerm)];
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:nil error:nil];
        NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"url: %@",url);
        NSString* artworkURL = [(NSArray*)resp[@"results"] firstObject][@"artworkUrl30"];
        if (artworkURL) {
            NSLog(@"artwork url: %@",artworkURL);
            artworkURL = [artworkURL stringByReplacingOccurrencesOfString:@".30x30-50.jpg" withString:@".400x400-75.jpg"];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:artworkURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *artworkData, NSError *connectionError) {
                UIImage* artwork = [UIImage imageWithData:artworkData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.artworkImageView.image = artwork;
                });
            }];
        }
        
        NSData* pretifiedResp = [NSJSONSerialization dataWithJSONObject:resp options:NSJSONWritingPrettyPrinted error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView setText:[[NSString alloc]initWithData:pretifiedResp encoding:NSUTF8StringEncoding]];
        });
    });
}

- (NSString*)optimizeString:(NSString*)s{
    s = [s rx_stringByReplacingMatchesOfPattern:@"\\(.*\\)" withTemplate:@""];
    s = [s stringByReplacingOccurrencesOfString:@"OST" withString:@""];
    s = [s stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    return s;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
