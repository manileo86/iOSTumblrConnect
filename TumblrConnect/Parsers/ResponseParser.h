#import <Foundation/Foundation.h>
#import "TumblrUser.h"

@interface ResponseParser : NSObject

//parse response for Tumblr blog name

+ (TumblrUser*)parseTumblrUserInfoResponse:(NSString*)response;
+ (NSString*)parseTumblrAvatarResponse:(NSString*)response;

@end

