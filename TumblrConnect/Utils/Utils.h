//
//  Utils.h
//  TumblrConnect
//
//  Created by Manigandan Parthasarathi on 16/09/12.
//  Copyright (c) 2012 Manigandan Parthasarathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TumblrUser.h"

@interface Utils : NSObject

+(void)saveCurrentUser:(TumblrUser *)object;
+(TumblrUser *)currentUser;

@end
