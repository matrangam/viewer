#import "RepoViewController.h"
#import "CommitViewController.h"
#import "JSONKit.h"

#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

@interface CommitViewController(private)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)getCommitsAndBranches:(NSString *)text;
- (void)getBranches:(NSString *)text;

@end

@implementation CommitViewController
@synthesize repoID;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *results = [NSDictionary dictionaryWithJSON:jsonString];

    branchData = [[results objectForKey:@"branches"] retain];
    commitData = [[results objectForKey:@"commits"] retain];



    debug(@"CommitData %@", commitData);
    debug(@"BranchData %@", branchData);
    
    [self.tableView reloadData];
    [jsonString release];
    
}

-(void)getCommitsAndBranches:(NSString *)text {

    NSString *branchString =[NSString stringWithFormat:@"https://github.com/api/v2/json/repos/show/matrangam/jQuery/branches"];
    NSURL *branch = [NSURL URLWithString:branchString];
    NSURLRequest *branchRequest = [[NSURLRequest alloc] initWithURL:branch]; 
    NSURLConnection *branchConnection = [[NSURLConnection alloc] initWithRequest:branchRequest delegate:self];

    [branchConnection release];
    [branchRequest release];
    
    NSString *commitString =[NSString stringWithFormat:@"https://github.com/api/v2/json/commits/list/matrangam/jQuery/master"];
    NSURL *commit = [NSURL URLWithString:commitString];
    NSURLRequest *commitRequest = [[NSURLRequest alloc] initWithURL:commit];
    NSURLConnection *commitConnection = [[NSURLConnection alloc] initWithRequest:commitRequest delegate:self];

    [commitConnection release];
    [commitRequest release];
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    commitData = [[NSMutableArray alloc] init];
    [self getCommitsAndBranches:@"matrangam"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [commitData release];
    [branchData release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

   return branchData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commitData.count;
}
/*
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //branchname
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *commits = [commitData objectAtIndex:indexPath.row];
    cell.textLabel.text = [commits valueForKeyPath:@"author.name"];
    cell.detailTextLabel.text = [[commits valueForKeyPath:@"tree"] substringToIndex:7];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
