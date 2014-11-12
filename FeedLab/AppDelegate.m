//
//  AppDelegate.m
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupApperance];
    return YES;
}

- (void)setupApperance {
    NSDictionary *attr = @{
      NSForegroundColorAttributeName : [UIColor blackColor],
      NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]
    };
    [[UINavigationBar appearance] setTitleTextAttributes:attr];
}

@end
