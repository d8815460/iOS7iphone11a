//
//  OmniCache.h
//  KitchenScale
//
//  Created by 陳 駿逸 on 13/5/8.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OmniCache : NSObject

+ (id)sharedCache;

- (void)clear;

//- (BOOL)followStatusForUser:(PFUser *)user;
//- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

//Facebook朋友
- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;

@end
