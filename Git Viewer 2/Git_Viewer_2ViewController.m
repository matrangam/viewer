#import "Git_Viewer_2ViewController.h"
#import "CommitViewController.h"
#import "JSONKit.h"

#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

@interface Git_Viewer_2ViewController(private)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)searchGitRepos:(NSString *)text;
@end

NSString *const searchParams = @"ztask";
NSString *const user = @"matrangam";

@implementation Git_Viewer_2ViewController

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
    debug(@"table %@", repoNames);
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

-(id)init {

    if (self = [super init]) {
        
        repoNames = [[NSMutableArray alloc] init];
        repoDescriptions = [[NSMutableArray alloc] init];
        repoData = [[NSMutableArray alloc] init];
        repoActivity = [[NSMutableArray alloc] init];
        
        [self searchGitRepos:@"matrangam"];

    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [repoNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text =  [repoNames objectAtIndex: [indexPath row]];
    cell.textLabel.textColor = [UIColor orangeColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitViewController *commitView = [[CommitViewController alloc] init];
    commitView.title = @"Commits";
    commitView.repoID = [repoNames objectAtIndex:indexPath.row];
    
    NSLog(@"got here");
    
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
