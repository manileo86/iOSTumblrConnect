//
//  ImageCache.h
//  PVA
//
//  Created by Ved Surtani on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MEMORY_CACHE_SIZE 0
#define IMAGE_CACHE_FOLDER_NAME @"TumblrConnect"

// 10 days in seconds
#define IMAGE_FILE_LIFETIME 864000.0


/*!
 @class		ImageCache
 @brief		Utility class for caching images on disk and retrieving them.
 @detaols	This class is meant to be singleton only because it keeps a memcache of images for fater retrieval.
 Purge strategy is FIFO. Image life time is determined by constant IMAGE_FILE_LIFETIME. Maximum cache size is determined by 
 MEMORY_CACHE_SIZE in MBs. 
 */
@interface ImageCacher : UIView 
{
@private
    NSMutableArray *keyArray;
    NSMutableDictionary *memoryCache;
    NSFileManager *fileManager;
}

/*!
 @brief		returns the shared singleton instance.
 */
+ (ImageCacher *)sharedInstance;


/*!
 @brief		retrieves image from cache for the specified key.
 @return	UIImage instance if the image was found, nil otherwise.
 */
- (UIImage *)imageForKey:(NSString *)key;

/*!
 @brief		returns true if an image is found in the cache. returns false otherwise.
 */
- (BOOL)hasImageWithKey:(NSString *)key;


/*!
 @brief		stores the image in cache for the specified key.
 */
- (void)storeImage:(UIImage *)image withKey:(NSString *)key;


/*!
 @brief		returns true if the cached image is also available in memcache.
 @details	this is used internally/externally to reduce disk reads.
 */
- (BOOL)imageExistsInMemory:(NSString *)key;


/*!
 @brief		returns true if image is already saved in disk, else returns false.
 */
- (BOOL)imageExistsInDisk:(NSString *)key;


/*!
 @brief		returns number of images in memcache.
 */
- (NSUInteger)countImagesInMemory;

/*!
 @brief		returns number of images cached in disk.
 */
- (NSUInteger)countImagesInDisk;


/*!
 @brief		removes the image with specified key from the cache.
 */
- (void)removeImageWithKey:(NSString *)key;

/*!
 @brief		call to this method will reset the cache.
 */
- (void)removeAllImages;

/*!
 @brief		call to this method will reset memcache. Disk cache will retain the images.
 */
- (void)removeAllImagesInMemory;

/*!
 @brief		Removes images that have lifetime greater than configured maximum life time defined by IMAGE_FILE_LIFETIME.
 */
- (void)removeOldImages;

@end
