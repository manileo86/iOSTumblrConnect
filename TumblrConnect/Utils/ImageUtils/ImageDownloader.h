//
//  ImageDownloader.h
//  fontli
//
//  Created by Ved Surtani on 22/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "ImageCacher.h"
#import "ASIHTTPRequest.h"

@protocol ImageDownloaderDelegate;
@interface ImageDownloader : NSObject
{
    id<ImageDownloaderDelegate> delegate;
    
@private
    ASIHTTPRequest *request;
    NSString *imageUrl;
    NSString *cacheKey; // key for image cache dictionary
    UIImage *image;
    int currentTag;
}

@property(nonatomic,assign)id<ImageDownloaderDelegate> delegate;
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,copy) NSString *cacheKey;
@property(nonatomic,retain)UIImage *image;

-(id)initWithImageUrl:(NSString*)imageUrl delegate:(id)delegate;
-(void)startLoadingImageFromUrl:(NSString*)url;
-(void)startLoadingImageFromUrl:(NSString*)url useCache:(BOOL)useCache;
-(void)startLoadingImageUsingCache:(BOOL)useCache;
@end


@protocol ImageDownloaderDelegate <NSObject>

-(void)imageDownloader:(ImageDownloader*)downloader retrievedImage:(UIImage*)image fromCache:(BOOL)cache;

@optional
-(void)imageDownloaderFailed:(ImageDownloader *)downloader;
@end
