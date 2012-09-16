//
//  ProfileViewController.h
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ProfileViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UILabel *blognameLabel;
@property (retain, nonatomic) IBOutlet AsyncImageView *userImageView;
@end
