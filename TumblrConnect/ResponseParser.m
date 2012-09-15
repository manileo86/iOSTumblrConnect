#import "ResponseParser.h"
#import "SBJSON.h"
#import "Constants.h"
#import <math.h>

@implementation ResponseParser

+ (NSString*)parseTumblrBlogNameResponse:(NSString*)response
{    
    SBJSON *sbJSON= [SBJSON new];
	
	NSDictionary *parsedData= [sbJSON objectWithString:response];
	if(parsedData && [parsedData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *infoDict = [parsedData objectForKey:kRequestResponseKey];
        if(infoDict && [infoDict isKindOfClass:[NSDictionary class]])
        {    
            NSDictionary *userDict = [infoDict objectForKey:@"user"];
            if(userDict && [userDict isKindOfClass:[NSDictionary class]])
            {
                NSString *blogname = [userDict objectForKey:@"name"];    
                return blogname;
            }
        }
    }
    return @"";
}

@end

