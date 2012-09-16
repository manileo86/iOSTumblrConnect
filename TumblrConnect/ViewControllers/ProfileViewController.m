//
//  ProfileViewController.m
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utils.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize tumblrUser;
@synthesize usernameLabel;
@synthesize followingCountLabel;
@synthesize userImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    usernameLabel.text = tumblrUser.username;
    followingCountLabel.text = [NSString stringWithFormat:@"%d",tumblrUser.followingCount];
    tumblrUtil = [[TumblrUtil alloc] initWithDelegate:self];
    if(tumblrUser.image)
    {
        [userImageView setImage:tumblrUser.image];
    }
    else if(tumblrUser.avatarUrl)
    {
        [userImageView setImageUrl:self.tumblrUser.avatarUrl];
    }
    else
    {
        [tumblrUtil requestAvatar];
    }
}

-(IBAction)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TumblrUtil delegate functions

-(void) tumblrAvatarStatus:(BOOL)status
{
    if(status)
    {
        self.tumblrUser = [Utils currentUser];

        if(tumblrUser.image)
        {
            [userImageView setImage:tumblrUser.image];
        }
        else if(tumblrUser.avatarUrl)
        {
            [userImageView setImageUrl:self.tumblrUser.avatarUrl];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setUsernameLabel:nil];
    [self setUserImageView:nil];
    [self setFollowingCountLabel:nil];
    
    tumblrUtil.delegate = nil;
    [tumblrUtil release];
    tumblrUtil = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    tumblrUtil.delegate = nil;
    [tumblrUtil release];
    tumblrUtil = nil;
    
    [tumblrUser release];
    [usernameLabel release];
    [userImageView release];
    [followingCountLabel release];
    [super dealloc];
}
@end
