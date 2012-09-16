//
//  TumblrViewController.h
//  Fontli
//
//  Created by Pramati Technologies on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrUtil.h"

@protocol TumblrViewControllerDelegate;

@interface TumblrViewController : UIViewController <UIWebViewDelegate, TumblrUtilDelegate>
{
    IBOutlet UIWebView *webView;
    TumblrUtil *tumblrUtil;
    IBOutlet UIActivityIndicatorView *loadingIndicatorView;
    
    id<TumblrViewControllerDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property(nonatomic, assign) id<TumblrViewControllerDelegate> delegate;

- (IBAction)cancelPressed;

@end

@protocol TumblrViewControllerDelegate <NSObject>

@optional
-(void)tumblrAuthenticationStatus:(BOOL)status;
-(void)tumblrPostStatus:(BOOL)status;

@end
