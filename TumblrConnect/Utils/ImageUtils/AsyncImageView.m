//
//  AsyncImageView.m
//  Fontli
//
//  Created by Ved Surtani on 26/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AsyncImageView
@synthesize imageUrl,delegate,shouldAnimate, Id;

-(AsyncImageView *) initWithFrame:(CGRect) frame withId:(NSString *)ID touches:(BOOL)allowsTouches withDelegate:(id) _delegate hasBorder:(BOOL) hasBorder
{
    NSLog(@"AsyncImageView : initWithFrame & delegate");
    
	self = [super init];
	
    if(!self)
    return nil;
    
    self.frame = frame;
    
    if(allowsTouches)
    self.userInteractionEnabled = YES;
    
    if(ID)
    self.Id = ID;
    
    if(_delegate)
    self.delegate = _delegate;    
    
    if(hasBorder)
    {  
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    // cancel the previous request otherwise when request is finished the downloaded image will be set
    // For example: First imageUrl was set, so the image is being downloaded. While the image is being downloaded
    // if someone sets the new image, it should show the new image and not the downloaded image, hence previous request should be cancelled.
    if (imageDownloader!= nil) {
        imageDownloader.delegate = nil;
        [imageDownloader release];
        imageDownloader = nil;
    }
    [super setImage:image];
}
-(void)setImageUrl:(NSString *)imageUrl_{

	[self setImageUrl:imageUrl_ useCache:YES];
}

-(void)setImageUrl:(NSString *)imageUrl_ useCache:(BOOL)useCache
{
    if(imageUrl_ == nil) 
    {
        [imageUrl release];
        imageUrl = nil;
        return;
    }
    
    if(imageUrl != imageUrl_)
    {
        NSString *temp = imageUrl;
        imageUrl = [imageUrl_ retain];
        [temp release];
    }
    
    //start the image download
    if(imageDownloader == nil)
    imageDownloader = [[ImageDownloader alloc] initWithImageUrl:imageUrl delegate:self];
    
  [imageDownloader startLoadingImageFromUrl:imageUrl_ useCache:useCache];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"AsyncImageView : touchesEnded");

    if(delegate && [delegate respondsToSelector:@selector(handleTapWithId:)])
    [delegate handleTapWithId:self.Id];
}

#pragma ImageDownloader delegate
-(void)imageDownloader:(ImageDownloader*)downloader retrievedImage:(UIImage*)image fromCache:(BOOL)cache
{
    self.image = image;
    
    /*if(shouldAnimate) 
    {
        [self.layer removeAnimationForKey:@"AsyncImageAnim"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transition.type = kCATransitionFade;
        
        [self.layer addAnimation:transition forKey:@"AsyncImageAnim"];  
    }*/
    
    if(delegate!=nil && [delegate respondsToSelector:@selector(didFinishLoadingImage:fromCache:)])
    [delegate didFinishLoadingImage:self.image fromCache:cache];
}

-(void)dealloc
{
    NSLog(@"AsyncImageView : dealloc");

    self.delegate=nil;
    
    if(imageDownloader != nil) 
    {
        imageDownloader.delegate = nil;
        [imageDownloader release];
        imageDownloader = nil;
    }
    
    [imageUrl release];
    [Id release];
    [super dealloc];
}
@end
