//
//  TumblrUtil.h
//  Fontli
//
//  Created by Pramati technologies on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "ASIHTTPRequest.h"

@protocol TumblrUtilDelegate;

@interface TumblrUtil : NSObject<ASIHTTPRequestDelegate>
{    
    id<TumblrUtilDelegate> delegate;
}

@property(nonatomic, assign) id<TumblrUtilDelegate> delegate;

+(void)setTumblrConfigured:(BOOL)configured;
+(BOOL)isTumblrConfigured;

-(id)initWithDelegate:(id)_delegate;

-(void)requestOAuthToken;
-(void)requestAccessToken;
-(void)requestBlogHostName;
-(void)sharePhotoOnTumblrWithUrl:(NSString *)originalURL
                        permalink:(NSString *)permalink
                          caption:(NSString *)caption;
-(void)requestAvatar;

-(void)logout;

@end

@protocol TumblrUtilDelegate <NSObject>

@optional
-(void)requestTokenStatus:(BOOL)status;
-(void)accessTokenStatus:(BOOL)status;
-(void)tumblrPostStatus:(BOOL)status;
-(void)tumblrAvatarStatus:(BOOL)status;

@end
