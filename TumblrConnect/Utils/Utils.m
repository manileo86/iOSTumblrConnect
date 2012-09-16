//
//  Utils.m
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+(void)saveCurrentUser:(TumblrUser *)object
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [prefs setObject:myEncodedObject forKey:kTumblrCurrentUserDefaultsKey];
}

+(TumblrUser *)currentUser
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:kTumblrCurrentUserDefaultsKey ];
    TumblrUser *obj = (TumblrUser *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

@end
