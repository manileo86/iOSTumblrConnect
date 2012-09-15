
//General API Response Keys
#define	kRequestSuccessValue						@"Success"
#define	kRequestFailureValue						@"Failure"
#define	kRequestStatusKey							@"status"
#define kRequestResponseKey							@"response"
#define kRequestErrorKey							@"errors"

#pragma mark -
#pragma mark Tumblr Constants

#define kIsTumblrConfigured                        @"isTumblrConfigured"
#define kIsTumblrOn                                @"isTumblrOn"

////////////////// App Dependent //////////////////////
#error Replace your App Consumer Key
#define kTumblrConsumerKey                         @"PASTE_YOUR_APP_CONSUMER_KEY_HERE"

#error Replace your App Consumer Secret Key
#define kTumblrConsumerSecret                      @"PASTE_YOUR_APP_CONSUMER_SECRET_KEY_HERE"

#error Replace your App Callback URL Key
#define kTumblrAppCallbackURL                      @"PASTE_YOUR_APP_CALLBACK_URL_HERE"

#define kTumblrRequestTokenURL                     @"http://www.tumblr.com/oauth/request_token"
#define kTumblrRequestTokenDefaultsKey             @"tumblr_request_key"

#define kTumblrAuthorizeURL                        @"http://www.tumblr.com/oauth/authorize"
#define kTumblrVerifierTokenDefaultsKey            @"tumblr_verifier_key"

#define kTumblrAccessTokenTokenURL                 @"http://www.tumblr.com/oauth/access_token"
#define kTumblrAccessTokenDefaultsKey              @"tumblr_accesstoken_key"

#define kTumblrBlogNameDefaultsKey                 @"tumblr_blogname_key"

#define kTumblrInfoURL                             @"http://api.tumblr.com/v2/user/info"

#define kTumblrLogoutURL                           @"http://www.tumblr.com/logout"
