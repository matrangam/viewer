//
//  Git_Viewer_2AppDelegate.m
//  Git Viewer 2
//
//  Created by Michael Matranga on 9/6/11.
//  Copyright 2011 DmgCtrl. All rights reserved.
//

#import "Git_Viewer_2AppDelegate.h"

@implementation Git_Viewer_2AppDelegate

@synthesize window;
@synthesize navigationController;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions  {
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    return YES;
    
}

@end
