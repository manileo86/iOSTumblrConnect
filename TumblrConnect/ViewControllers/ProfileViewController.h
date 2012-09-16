//
//  ProfileViewController.h
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TumblrUser.h"
#import "TumblrUtil.h"

@interface ProfileViewController : UIViewController<TumblrUtilDelegate>
{
    TumblrUtil *tumblrUtil;
}

@property (retain, nonatomic) TumblrUser *tumblrUser;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (retain, nonatomic) IBOutlet AsyncImageView *userImageView;
@end
