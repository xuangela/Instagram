//
//  HomeViewController.m
//  Instagram
//
//  Created by Angela Xu on 7/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "PostDetailViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "PostCell.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *posts;  // array of Posts

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchPosts:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self fetchPosts:refreshControl];
}


- (void)fetchPosts: (UIRefreshControl *)refreshControl{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = [Post postsWithDictionaries:posts];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didPost:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)tapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * error) {   }];
}

#pragma mark - Table view set up

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
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
    
    double picHeightDouble =picRatio * self.tableView.frame.size.width;
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

- (IBAction)unwindToContainerVC:(UIStoryboardSegue *)segue {
    
}

@end
