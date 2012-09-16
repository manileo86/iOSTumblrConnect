//
//  AsyncImageView.h
//  Fontli
//
//  Created by Ved Surtani on 26/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
@protocol AsyncImageDelegate;

@interface AsyncImageView : UIImageView<ImageDownloaderDelegate>
{
    NSString *imageUrl;
    id<AsyncImageDelegate> delegate;
    BOOL shouldAnimate;
    NSString *Id;

@private
    ImageDownloader *imageDownloader;
}

/*!
 @property      imageUrl
 @brief         setting this property will set the imageUrl string and the instance will attempt to load the image from the given url. On download the image will be set.
 */
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,assign) id<AsyncImageDelegate> delegate;
@property(nonatomic) BOOL shouldAnimate;
@property(nonatomic, retain) NSString *Id;

-(void)setImageUrl:(NSString *)imageUrl_ useCache:(BOOL)useCache;
-(AsyncImageView *) initWithFrame:(CGRect) frame withId:(NSString *)ID touches:(BOOL)allowsTouches withDelegate:(id) _delegate hasBorder:(BOOL) hasBorder;

@end

@protocol AsyncImageDelegate <NSObject>

@optional
-(void) didFinishLoadingImage:(UIImage *)image fromCache:(BOOL)cache;
-(void) handleTapWithId:(NSString *)ID;
@end