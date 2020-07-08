//
//  PostCell.h
//  Instagram
//
//  Created by Angela Xu on 7/7/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (nonatomic, strong) Post *post;

- (void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
