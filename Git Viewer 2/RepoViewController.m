//
//  RepoViewController.m
//  Git Viewer 2
//
//  Created by Michael Matranga on 9/7/11.
//  Copyright 2011 DmgCtrl. All rights reserved.
//

#import "RepoViewController.h"
#import "CommitViewController.h"
#import "JSONKit.h"

#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

@interface RepoViewController(private)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)searchGitRepos:(NSString *)text;
@end

NSString *const searchParams = @"ztask";
NSString *const user = @"matrangam";

@implementation RepoViewController

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *results = [NSDictionary dictionaryWithJSON:jsonString];
    NSDictionary *repos = [results objectForKey:@"repositories"];
    
    for (NSDictionary *repo in repos) {
        
        NSString *name = [repo objectForKey:@"name"];
        [repoNames addObject:(name.length > 0 ? name : @"Untitled")];
        
        NSString *description = [repo objectForKey:@"description"];
        [repoDescriptions addObject:(description.length > 0 ? description:@"No Description")];
        
        NSString *last_push = [repo objectForKey:@"pushed_at"];
        [repoActivity addObject:(last_push.length > 0 ? last_push:@"No Activity")];
        
        NSString *repoURLString = [NSString stringWithFormat:@"https://github.com/api/v2/json/repos/show/%@", user];
        repoURLString = [NSString stringWithFormat:@"https://github.com/api/v2/json/repos/show/%@", user];        
        [repoData addObject:[NSURL URLWithString:repoURLString]];
        
    }
    debug(@"table =====> %@", repoNames);
    [self.tableView reloadData];
    [jsonString release];
}

-(void)searchGitRepos:(NSString *)text {
    
    NSString *urlString =[NSString stringWithFormat:@"https://github.com/api/v2/json/repos/show/%@", user, text];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
    [request release];
}


- (id)initWithStyle:(UITableViewStyle)style {

    self = [super initWithStyle:style];
    if (self) {        
    
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    repoNames = [[NSMutableArray alloc] init];
    repoDescriptions = [[NSMutableArray alloc] init];
    repoData = [[NSMutableArray alloc] init];
    repoActivity = [[NSMutableArray alloc] init];
    [self searchGitRepos:@"matrangam"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [repoNames count];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text =  [repoNames objectAtIndex: [indexPath row]];
    cell.textLabel.textColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitViewController *commitView = [[CommitViewController alloc] init];
    commitView.title = @"Commits";
    commitView.repoID = [repoNames objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:commitView animated:YES];    
    
}
- (void)dealloc {
    [repoNames release];
    [repoDescriptions release];
    [repoData release];
    [repoActivity release];
    [super dealloc];
}
@end
