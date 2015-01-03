//
//  AVKDashboardRootViewController.m
//  AudioVK
//
//  Created by Roman Gardukevich on 12/12/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import "AVKDashboardRootViewController.h"


@interface AVKDashboardRootViewController ()

@end

@implementation AVKDashboardRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = [[PFUser currentUser] description];
}

-(void)logout{
    [PFUser logOut];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .3;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController popViewControllerAnimated:NO];
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
