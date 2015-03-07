//
//  AVKMyMusicPlaylistViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 1/21/15.
//  Copyright (c) 2015 Roman Gardukevich. All rights reserved.
//

#import "AVKMyMusicPlaylistViewController.h"

@interface AVKMyMusicPlaylistViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AVKMyMusicPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel* label = [[UILabel alloc] initWithFrame:self.view.bounds];
    [label setText:NSStringFromClass(self.class)];
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}



@end
