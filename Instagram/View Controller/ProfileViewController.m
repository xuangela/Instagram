//
//  ProfileViewController.m
//  Instagram
//
//  Created by Angela Xu on 7/10/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "PostDetailViewController.h"
#import "InfiniteScrollActivityView.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "PostCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *posts;  // array of Posts
@property (nonatomic, strong)UIRefreshControl *refreshControl;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;
@property (nonatomic, assign) BOOL isMoreDataLoading;
@property (nonatomic, assign) int timesGetMore;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self; 
    
    [self refreshSetUp];
    [self infiniteScrollLoadSetUp];
    
    [self fetchPosts];
}

- (void)infiniteScrollLoadSetUp {
    CGRect frame = CGRectMake(0, self.tableview.contentSize.height, self.tableview.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableview addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tableview.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableview.contentInset = insets;
}

- (void)refreshSetUp {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableview insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"user"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = [Post postsWithDictionaries:posts];
            [self.tableview reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didPost:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self.tableview reloadData];
}

- (IBAction)tapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * error) {   }];
}

#pragma mark - Infinite scrolling set up

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableview.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableview.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableview.isDragging) {
            self.isMoreDataLoading = YES;
            
            CGRect frame = CGRectMake(0, self.tableview.contentSize.height, self.tableview.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            [self loadMoreData];
        }
    }
}

- (void) loadMoreData {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"user"];
    query.skip = 20 * (1 + self.timesGetMore);
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSArray *newPosts =[Post postsWithDictionaries:posts];
            self.posts = [self.posts arrayByAddingObjectsFromArray:newPosts];
            
            self.timesGetMore += 1;
            self.isMoreDataLoading = NO;
            [self.loadingMoreView stopAnimating];
            
            [self.tableview reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Table view set up

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post =self.posts[indexPath.row];
    
    [cell setPost:post];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post =self.posts[indexPath.row];
    
    CGFloat picRatio = [post.picAspectRatio doubleValue];
    
    double picHeightDouble =picRatio * self.tableview.frame.size.width;
    post.picHeight = [NSNumber numberWithDouble:picHeightDouble];
    // 36 hardcoded. 20 set height for caption + 8 + 8 for top and bottom space
    return picHeightDouble + 36;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        PostDetailViewController *detailController = [segue destinationViewController];
        PostCell *tappedCell = sender;
        detailController.post = tappedCell.post;
    }
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
