//
//  ViewController.m
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 15/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "TumblrUtil.h"
#import "Reachability.h"
#import "Utils.h"
#import "TumblrUser.h"

@interface HomeViewController ()
{
    BOOL loggedIn;
}

-(void)showSuccessfulLogin;
-(void)logoutAction;

@end

@implementation HomeViewController
@synthesize loginButton;
@synthesize loggedInAsLabel;
@synthesize usernameLabel;
@synthesize continueButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.userInteractionEnabled = [[Reachability reachabilityForInternetConnection] isReachable];
    
    if([TumblrUtil isTumblrConfigured])
    {
        [self showSuccessfulLogin];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reachabilityChanged
{
    self.view.userInteractionEnabled = [[Reachability reachabilityForInternetConnection] isReachable];
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setLoggedInAsLabel:nil];
    [self setUsernameLabel:nil];
    [self setContinueButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)loginPressed:(id)sender
{
    if(loggedIn)
    {
        [self logoutAction];
    }
    else
    {
        TumblrViewController *viewController = [[TumblrViewController alloc] init];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

-(IBAction)continuePressed:(id)sender
{
    TumblrUser *tumblrUser = [Utils currentUser];
    if(tumblrUser)
    {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profileViewController.tumblrUser = tumblrUser;
        [self.navigationController pushViewController:profileViewController animated:YES];
        [profileViewController release];
    }
    else
    {
        [self logoutAction];
    }
}

#pragma mark -
#pragma mark TumblrViewController delegate functions

-(void) tumblrAuthenticationStatus:(BOOL)status
{
    if(status)
    {
        [self performSelector:@selector(showSuccessfulLogin) withObject:nil afterDelay:0.75];
    }
}

-(void) tumblrPostStatus:(BOOL)status
{
    if(status)
    {
        
    }
}

-(void)showSuccessfulLogin
{
    TumblrUser *tumblrUser = [Utils currentUser];
    if(tumblrUser==nil)
    {
        [self logoutAction];
        return;
    }
    
    [usernameLabel setText:tumblrUser.username];
    loggedInAsLabel.alpha = 1.0;
    usernameLabel.alpha = 1.0;
    [UIView animateWithDuration:0.45
                     animations:^{
                         loginButton.frame = CGRectMake(116, 316, 88, 37);
                         loggedInAsLabel.frame = CGRectMake(124, 252, 80, 21);
                         usernameLabel.frame = CGRectMake(38, 275, 235, 25);
                         continueButton.frame = CGRectMake(116, 404, 88, 37);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              loggedInAsLabel.frame = CGRectMake(120, 252, 80, 21);
                                              usernameLabel.frame = CGRectMake(43, 275, 235, 25);
                                              [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
                                          }];
                     }];
    
    loggedIn = YES;
}

-(void)logoutAction
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         loggedInAsLabel.frame = CGRectMake(124, 252, 80, 21);
                         usernameLabel.frame = CGRectMake(38, 275, 235, 25);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.45
                                          animations:^{
                                              loginButton.frame = CGRectMake(116, 259, 88, 37);
                                              loggedInAsLabel.frame = CGRectMake(-80, 252, 80, 21);
                                              usernameLabel.frame = CGRectMake(320, 275, 235, 25);
                                              loggedInAsLabel.alpha = 0;
                                              usernameLabel.alpha = 0;
                                              continueButton.frame = CGRectMake(116, 460, 88, 37);
                                          }
                                          completion:^(BOOL finished) {
                                              [loginButton setTitle:@"Login" forState:UIControlStateNormal];
                                          }];
                     }];
    
    loggedIn = NO;
    [TumblrUtil setTumblrConfigured:NO];
    [Utils saveCurrentUser:nil];
}

- (void)dealloc
{
    [loginButton release];
    [loggedInAsLabel release];
    [usernameLabel release];
    [continueButton release];
    [super dealloc];
}

@end
