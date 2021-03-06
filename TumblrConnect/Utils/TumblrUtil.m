//
//  TumblrUtil.m
//  Fontli
//
//  Created by Pramati technologies on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TumblrUtil.h"
#import "OARequestParameter.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "ResponseParser.h"
#import "Utils.h"

@implementation TumblrUtil

@synthesize delegate;

+(void)setTumblrConfigured:(BOOL)configured
{
    [[NSUserDefaults standardUserDefaults] setBool:configured forKey:kIsTumblrConfigured];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isTumblrConfigured
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsTumblrConfigured];
}

-(id)initWithDelegate:(id)_delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = _delegate;
    }
    return self;
}

#pragma mark - OAuth RequestToken

-(void)requestOAuthToken
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    NSURL *url = [NSURL URLWithString:kTumblrRequestTokenURL];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [consumer release];
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        if(delegate && [delegate respondsToSelector:@selector(requestTokenStatus:)])
        {
            NSString *responseBody = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
            OAToken *oaRequestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
            [oaRequestToken storeInUserDefaultsWithServiceProviderName:kTumblrRequestTokenDefaultsKey prefix:@"TumblrConnect"];
            [oaRequestToken release];
            
            [delegate requestTokenStatus:YES];
        }
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Tumblr Request Token Failed - %@", error.description);
    
    if(delegate && [delegate respondsToSelector:@selector(requestTokenStatus:)])
    {
        [delegate requestTokenStatus:NO];
    }
}

#pragma mark - OAuth AccessToken

-(void)requestAccessToken
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kTumblrAccessTokenTokenURL]];
    
    OAToken *reqToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kTumblrRequestTokenDefaultsKey prefix:@"TumblrConnect"];
    reqToken.pin = [[NSUserDefaults standardUserDefaults] valueForKey:kTumblrVerifierTokenDefaultsKey];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:reqToken
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [consumer release];
    [reqToken release];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        OAToken *aToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [aToken storeInUserDefaultsWithServiceProviderName:kTumblrAccessTokenDefaultsKey prefix:@"TumblrConnect"];
        [aToken release];
        
        [self requestBlogHostName];
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Tumblr Request Token Failed - %@", error.description);
    
    if(delegate && [delegate respondsToSelector:@selector(accessTokenStatus:)])
    {
        [delegate accessTokenStatus:NO];
    }
}

#pragma mark - Tumblr Blog name

-(void)requestBlogHostName
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kTumblrInfoURL]];
    
    OAToken *authToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kTumblrAccessTokenDefaultsKey prefix:@"TumblrConnect"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:authToken
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [consumer release];
    [authToken release];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(infoTicket:didFinishWithData:)
                  didFailSelector:@selector(infoTicket:didFailWithError:)];
}

- (void)infoTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        if(delegate && [delegate respondsToSelector:@selector(accessTokenStatus:)])
        {
            // parse info
            NSString *responseBody = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
            TumblrUser *tumblrUser = [ResponseParser parseTumblrUserInfoResponse:responseBody];
            if(tumblrUser)
            {
                [Utils saveCurrentUser:tumblrUser];
                [TumblrUtil setTumblrConfigured:YES];
                [delegate accessTokenStatus:YES];
            }
            else
            {
                [TumblrUtil setTumblrConfigured:NO];
                [delegate accessTokenStatus:NO];
            }
        }
    }
}

- (void)infoTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Tumblr Request Token Failed - %@", error.description);
    
    if(delegate && [delegate respondsToSelector:@selector(accessTokenStatus:)])
    {
        [delegate accessTokenStatus:NO];
    }
}

#pragma mark - Post on Tumblr

- (void)sharePhotoOnTumblrWithUrl:(NSString *)originalURL
                        permalink:(NSString *)permalink
                          caption:(NSString *)caption
{
    OAToken *authToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kTumblrAccessTokenDefaultsKey prefix:@"TumblrConnect"];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    TumblrUser *tumblrUser = [Utils currentUser];
    NSString *username = (tumblrUser!=nil)?tumblrUser.username:@"";
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/post", username];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]
                                                                   consumer:consumer
                                                                      token:authToken
                                                                      realm:@"http://api.tumblr.com"
                                                          signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    if(!caption)
    {
        caption = @"Tumblr post";
    }
    
    [request setParameters:[NSArray arrayWithObjects:
                            [OARequestParameter requestParameterWithName:@"type" value:@"photo"],
                            [OARequestParameter requestParameterWithName:@"caption" value:caption],
                            [OARequestParameter requestParameterWithName:@"source" value:originalURL],
                            [OARequestParameter requestParameterWithName:@"link" value:permalink],
                            nil]];
    [request prepare];
    NSString *oAuthHeader = [request valueForHTTPHeaderField:@"Authorization"];
    NSLog(@"OAuthHeader : %@", oAuthHeader);
    [request release];
    
    ASIFormDataRequest *postRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [postRequest setDelegate:self];
    [postRequest setRequestMethod:@"POST"];
    [postRequest addRequestHeader:@"Authorization" value:oAuthHeader];
    [postRequest addPostValue:@"photo" forKey:@"type"];
    [postRequest addPostValue:caption forKey:@"caption"];
    [postRequest addPostValue:originalURL forKey:@"source"];
    [postRequest addPostValue:permalink forKey:@"link"];
    [postRequest startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTPRequest functions

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"TumblrUtil : requestFinished");
    
	if(delegate!=nil && [delegate respondsToSelector:@selector(tumblrPostStatus:)])
        [delegate tumblrPostStatus:YES];
    request.delegate = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"TumblrUtil : requestFailed");
	
    if(delegate!=nil && [delegate respondsToSelector:@selector(tumblrPostStatus:)])
        [delegate tumblrPostStatus:NO];
    
    request.delegate = nil;
}

#pragma mark -
#pragma mark Avatar

-(void)requestAvatar
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    TumblrUser *tumblrUser = [Utils currentUser];
    NSString *username = (tumblrUser!=nil)?tumblrUser.username:@"";
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", username];
    
    OAToken *authToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kTumblrAccessTokenDefaultsKey prefix:@"TumblrConnect"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]
                                                                   consumer:consumer
                                                                      token:authToken
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [consumer release];
    [authToken release];
    
    [request setHTTPMethod:@"GET"];
    
    [request setParameters:[NSArray arrayWithObjects:
                            [OARequestParameter requestParameterWithName:@"size" value:kTumblrAvatarSize],
                            nil]];
    
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(avatarTicket:didFinishWithData:)
                  didFailSelector:@selector(avatarTicket:didFailWithError:)];
}

- (void)avatarTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        if(delegate && [delegate respondsToSelector:@selector(tumblrAvatarStatus:)])
        {
            // parse info
            
            UIImage *image = [UIImage imageWithData:data];
            if(image)
            {
                //NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSString *imageUrl = [ResponseParser parseTumblrAvatarResponse:responseBody];
                TumblrUser *tumblrUser = [Utils currentUser];
                if(tumblrUser)
                {
                    tumblrUser.image = image;
                    [Utils saveCurrentUser:tumblrUser];
                    [delegate tumblrAvatarStatus:YES];
                }
                else
                {
                    [delegate tumblrAvatarStatus:NO];
                }
            }
        }
    }
}

- (void)avatarTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Tumblr Request Token Failed - %@", error.description);
    
    if(delegate && [delegate respondsToSelector:@selector(tumblrAvatarStatus:)])
    {
        [delegate tumblrAvatarStatus:NO];
    }
}

#pragma mark -
#pragma mark Logout

-(void)logout
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kTumblrConsumerKey
                                                    secret:kTumblrConsumerSecret];
    
    NSURL *url = [NSURL URLWithString:kTumblrLogoutURL];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [consumer release];
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(logoutTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(logoutTokenTicket:didFailWithError:)];
}

- (void)logoutTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        NSLog(@"Logged out");
    }
}

- (void)logoutTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Logout failed - %@", error.description);
}

-(void)dealloc
{
    delegate = nil;
    [super dealloc];
}

@end