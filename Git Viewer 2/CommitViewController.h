//
//  CommitViewController.h
//  Git Viewer 2
//
//  Created by Michael Matranga on 9/7/11.
//  Copyright 2011 DmgCtrl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitViewController : UITableViewController {
    NSString* repoID;
    NSMutableArray *authorNames;
    NSMutableArray *commitHashes;
    NSMutableArray *commitMessages;
    NSMutableArray *commitUrls;
    NSMutableArray *commitData;    
}

@property(nonatomic, retain) NSString* repoID;

@end
