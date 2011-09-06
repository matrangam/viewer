//
//  Git_Viewer_2AppDelegate.h
//  Git Viewer 2
//
//  Created by Michael Matranga on 9/6/11.
//  Copyright 2011 DmgCtrl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Git_Viewer_2ViewController;

@interface Git_Viewer_2AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Git_Viewer_2ViewController *viewController;

@end
