//
//  TumblrUser.h
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TumblrUser : NSObject

@property(nonatomic, retain) NSString *username;
@property(nonatomic) NSUInteger followingCount;
@property(nonatomic, retain) NSString *avatarUrl;
@property(nonatomic, retain) UIImage *image;
@end
