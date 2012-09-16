//
//  ViewController.h
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 15/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrViewController.h"

@interface HomeViewController : UIViewController<TumblrViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UILabel *loggedInAsLabel;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UIButton *continueButton;
@end
