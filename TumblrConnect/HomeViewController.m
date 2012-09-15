//
//  ViewController.m
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 15/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import "HomeViewController.h"
#import "TumblrUtil.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if([TumblrUtil isTumblrConfigured])
    {
        [self showSuccessfulLogin];
    }
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setLoggedInAsLabel:nil];
    [self setUsernameLabel:nil];
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
    [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    [usernameLabel setText:[TumblrUtil getBlogName]];
    loggedInAsLabel.alpha = 1.0;
    usernameLabel.alpha = 1.0;
    [UIView animateWithDuration:0.45
                     animations:^{
                         loginButton.frame = CGRectMake(116, 316, 88, 37);
                         loggedInAsLabel.frame = CGRectMake(124, 252, 80, 21);
                         usernameLabel.frame = CGRectMake(38, 278, 235, 25);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              loggedInAsLabel.frame = CGRectMake(120, 252, 80, 21);
                                              usernameLabel.frame = CGRectMake(43, 278, 235, 25);
                                          }];
                     }];
    
    loggedIn = YES;
}

-(void)logoutAction
{
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2
                     animations:^{
                         loggedInAsLabel.frame = CGRectMake(124, 252, 80, 21);
                         usernameLabel.frame = CGRectMake(38, 278, 235, 25);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.45
                                          animations:^{
                                              loginButton.frame = CGRectMake(116, 259, 88, 37);
                                              loggedInAsLabel.frame = CGRectMake(-80, 252, 80, 21);
                                              usernameLabel.frame = CGRectMake(320, 278, 235, 25);
                                              loggedInAsLabel.alpha = 0;
                                              usernameLabel.alpha = 0;
                                          }];
                     }];
    
    loggedIn = NO;
    [TumblrUtil setTumblrConfigured:NO];
}

- (void)dealloc {
    [loginButton release];
    [loggedInAsLabel release];
    [usernameLabel release];
    [super dealloc];
}
@end
