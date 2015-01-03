//
//  AVKDashboardRootViewController.h
//  AudioVK
//
//  Created by Roman Gardukevich on 12/12/14.
//  Copyright (c) 2014 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVKDashboardRootViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView* textView;

-(IBAction)logout;

@end
