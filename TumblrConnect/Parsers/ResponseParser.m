#import "ResponseParser.h"
#import "SBJSON.h"
#import "Constants.h"

@implementation ResponseParser

+ (TumblrUser*)parseTumblrUserInfoResponse:(NSString*)response
{    
    SBJSON *sbJSON= [SBJSON new];
    	
    TumblrUser *tumblrUser = nil;
    
	NSDictionary *parsedData= [sbJSON objectWithString:response];
	if(parsedData && [parsedData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *infoDict = [parsedData objectForKey:kRequestResponseKey];
        if(infoDict && [infoDict isKindOfClass:[NSDictionary class]])
        {    
            NSDictionary *userDict = [infoDict objectForKey:@"user"];
            if(userDict && [userDict isKindOfClass:[NSDictionary class]])
            {
                tumblrUser = [[[TumblrUser alloc] init] autorelease];

                NSString *username = [userDict objectForKey:@"name"];
                tumblrUser.username = username;
                
                NSUInteger followingCount = [[userDict objectForKey:@"following"] unsignedIntegerValue];
                tumblrUser.followingCount = followingCount;
                
                return tumblrUser;
            }
        }
    }
    return tumblrUser;
}

+ (NSString*)parseTumblrAvatarResponse:(NSString*)response
{
    SBJSON *sbJSON= [SBJSON new];
        
	NSDictionary *parsedData= [sbJSON objectWithString:response];
	if(parsedData && [parsedData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *responseDict = [parsedData objectForKey:kRequestResponseKey];
        if(responseDict && [responseDict isKindOfClass:[NSDictionary class]])
        {
            return [responseDict objectForKey:@"avatar_url"];
        }
    }
    return @"";
}

@end

