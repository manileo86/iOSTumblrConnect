//
//  TumblrUser.m
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import "TumblrUser.h"

@implementation TumblrUser
@synthesize username, followingCount, avatarUrl, image;

/* This code has been added to support encoding and decoding my objecst */

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode the properties of the object
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:[NSNumber numberWithUnsignedInt:self.followingCount] forKey:@"followingCount"];
    [encoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [encoder encodeObject:self.image forKey:@"image"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil )
    {
        //decode the properties
        self.username = [decoder decodeObjectForKey:@"username"];
        self.followingCount = [[decoder decodeObjectForKey:@"followingCount"] unsignedIntegerValue];
        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        self.image = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

-(void)dealloc
{
    [username release];
    [avatarUrl release];
    [image release];
    [super dealloc];
}

@end
