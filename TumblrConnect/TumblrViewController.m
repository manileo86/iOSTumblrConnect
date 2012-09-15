//
//  TumblrViewController.m
//  Fontli
//
//  Created by Pramati Technologies on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TumblrViewController.h"
#import "Constants.h"
#import "ResponseParser.h"

@interface TumblrViewController ()

@end

@implementation TumblrViewController

@synthesize webView, loadingIndicatorView, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"TumblrViewController: viewDidLoad");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    tumblrUtil = [[TumblrUtil alloc] initWithDelegate:self];
    [tumblrUtil logout];
    [tumblrUtil requestOAuthToken];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark tableView dataSource methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingIndicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *checkString = [[request URL] absoluteString];
    
    if([checkString hasPrefix:kTumblrAppCallbackURL])
    {
        if ([checkString rangeOfString:@"&oauth_verifier="].location != NSNotFound)
        {
            //got auth
            NSRange verifierRange = [checkString rangeOfString:@"&oauth_verifier="];
            NSString *verifier = [checkString substringFromIndex:verifierRange.location + verifierRange.length];
            [[NSUserDefaults standardUserDefaults] setValue:verifier forKey:kTumblrVerifierTokenDefaultsKey];
            [tumblrUtil requestAccessToken];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark TumblrUtil delegate functions

-(void)requestTokenStatus:(BOOL)status
{
    if(status)
    {
        OAToken *reqToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kTumblrRequestTokenDefaultsKey prefix:@"Fontli"];
        
        [webView loadRequest:
         [NSURLRequest requestWithURL:
          [NSURL URLWithString:
           [NSString stringWithFormat:@"%@?oauth_token=%@", kTumblrAuthorizeURL, reqToken.key]]]];
        
        [reqToken release];
    }
    else
    {
        if(delegate && [delegate respondsToSelector:@selector(tumblrAuthenticationStatus:)])
        {
            [delegate tumblrAuthenticationStatus:NO];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)accessTokenStatus:(BOOL)status
{    
    if(delegate && [delegate respondsToSelector:@selector(tumblrAuthenticationStatus:)])
    {
        [delegate tumblrAuthenticationStatus:status];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tumblrPostStatus:(BOOL)status
{
    if(delegate && [delegate respondsToSelector:@selector(tumblrPostStatus:)])
    {
        [delegate tumblrPostStatus:status];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    NSLog(@"TumblrViewController: didReceiveMemoryWarning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    NSLog(@"TumblrViewController : viewDidUnload");
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.webView = nil;
    self.loadingIndicatorView = nil;
}

-(void) dealloc
{
    NSLog(@"TumblrViewController : dealloc");
    
    delegate = nil;
    [webView release];
    [loadingIndicatorView release];
    [super dealloc];
}


@end
