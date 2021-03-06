//
//  PostDetailViewController.m
//  Instagram
//
//  Created by Angela Xu on 7/9/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "PostDetailViewController.h"
#import "NSDate+DateTools.h"
#import "Post.h"

@interface PostDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet PFImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIView *picContainerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;


@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self scrollAndStack];
    [self displayPostInfo];
}
 
- (void) scrollAndStack {
    [self.scrollView addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
    [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
    
}

- (void)displayPostInfo {
    
    self.userLabel.text = [self.post.user objectForKey:@"username"];
    self.captionLabel.text = self.post.caption;
    self.timestampLabel.text = [[self.post.timestamp shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
    
    [self.picContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGRect newFrame = self.picContainerView.frame;
    newFrame.size.height = [self.post.picHeight doubleValue];
    [self.picContainerView setFrame:newFrame];
    
    self.pictureView.file = self.post.picture;
    [self.pictureView loadInBackground];
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
