//
//  Post.h
//  Instagram
//
//  Created by Angela Xu on 7/8/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property (nonatomic, strong) NSString* caption;
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, strong) PFFileObject *picture;
@property (nonatomic, strong) PFUser *user;

- (id)initWithPFObject:(PFObject *)postPF;

+ (NSMutableArray *)postsWithDictionaries: (NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
