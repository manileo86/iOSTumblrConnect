#import <Foundation/Foundation.h>

@interface ResponseParser : NSObject

//parse response for Tumblr blog name

+ (NSString*)parseTumblrBlogNameResponse:(NSString*)response;


@end

