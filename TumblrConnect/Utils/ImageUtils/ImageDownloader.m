//
//  ImageDownloader.m
//  fontli
//
//  Created by Ved Surtani on 22/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


static int downloadTag = 999;
#import "ImageDownloader.h"
@interface ImageDownloader (Private)
-(NSString*)hashFromString:(NSString*)aString;
-(void)notifyDelegateFromCache:(NSNumber *) cache;
@end



@implementation ImageDownloader
@synthesize delegate;
@synthesize imageUrl,cacheKey,image;
-(id) initWithImageUrl:(NSString *)imageUrl_ delegate:(id)delegate_
{
    self = [super init];
    self.imageUrl = imageUrl_;
    self.delegate = delegate_;
    return self;
}

-(void)dealloc
{
    [cacheKey release];
    [imageUrl release];
    [image release];
    if (request != nil) {
        [request clearDelegatesAndCancel];
        [request release];
    }
    [super dealloc];
}


-(void)startLoadingImageFromUrl:(NSString*)url{
	
	[self startLoadingImageFromUrl:url useCache:YES];
}

-(void)startLoadingImageFromUrl:(NSString*)url useCache:(BOOL)useCache
{
    
    self.imageUrl = url;
    [self startLoadingImageUsingCache:useCache];
}


-(void)startLoadingImageUsingCache:(BOOL)useCache {
	
    currentTag = downloadTag++;
    
    NSURL *url= [NSURL URLWithString:imageUrl];	
    if (request != nil) {
        [request clearDelegatesAndCancel];
        [request release];
        request = nil;
    }
    
    if (image != nil) {
        self.image = nil;
    }
    
    if (useCache) {
        
        self.cacheKey = [self hashFromString:imageUrl];
        // Retrieve the image back
        
        if ([[ImageCacher sharedInstance] hasImageWithKey:cacheKey]) {
            self.image = [[ImageCacher sharedInstance] imageForKey:cacheKey] ;
            [self notifyDelegateFromCache:[NSNumber numberWithBool:YES]];
            return;
        }
    }
    

	request = [ASIHTTPRequest requestWithURL:url];
    [request retain];
    request.tag = currentTag;
    [request setDelegate:self];
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request_
{
    
	// Use when fetching binary data
	
	NSData *responseData = [request responseData];
	self.image = [[[UIImage alloc] initWithData:responseData] autorelease];
    
	[[ImageCacher sharedInstance] storeImage:image withKey:cacheKey];
	
    if (request.tag == currentTag) {
        [self performSelectorOnMainThread:@selector(notifyDelegateFromCache:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request_
{    
	if(request.tag == currentTag)
    {
        [self performSelectorOnMainThread:@selector(notifyFailureDelegate) withObject:nil waitUntilDone:NO];
    }
}

-(void)notifyFailureDelegate
{
    if (delegate!= nil && [delegate respondsToSelector:@selector(imageDownloaderFailed:)])
    {
        [delegate imageDownloaderFailed:self];
    }
}

-(void)notifyDelegateFromCache:(NSNumber *) cache
{
    if (delegate!= nil && [delegate respondsToSelector:@selector(imageDownloader:retrievedImage:fromCache:)]) {
//        [delegate performSelector:@selector(imageDownloader:retrievedImage:) withObject:self withObject:image];
        [delegate imageDownloader:self retrievedImage:image fromCache:[cache boolValue]];
    }
}

-(NSString*)hashFromString:(NSString*)str
{
	const char *cStr = [str UTF8String];
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
	
}



@end
