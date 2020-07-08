//
//  PostCell.m
//  Instagram
//
//  Created by Angela Xu on 7/7/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "PostCell.h"
#import <Parse/PFImageView.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    self.pictureView.file = post.picture;
    [self.pictureView loadInBackground];
}

@end
