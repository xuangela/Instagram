//
//  Post.m
//  Instagram
//
//  Created by Angela Xu on 7/8/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Post.h"

@implementation Post

- (id)initWithPFObject:(PFObject *)postPF {
    self = [super init];
    
    self.user = [postPF objectForKey:@"user"];
    self.picture = [postPF objectForKey:@"picture"];
    self.caption = [postPF objectForKey:@"caption"];
    self.timestamp = [postPF objectForKey:@"createdAt"];
    
    return self;
}

+ (NSMutableArray *)postsWithDictionaries: (NSArray *)dictionaries {
    NSMutableArray *postArray = [[NSMutableArray alloc] init];
    
    for (PFObject *dictionary in dictionaries) {
        Post *post = [[Post alloc] initWithPFObject:dictionary];
        [postArray addObject:post];
    }
    
    return postArray;
}

@end
