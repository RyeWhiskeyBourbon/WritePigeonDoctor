//
//  UMComKit+String.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"

@interface UMComKit (String)

+ (BOOL)checkEmailFormat:(NSString *)emailString;
+ (BOOL)includeSpecialCharact:(NSString *)sourceString;
+ (BOOL)includeAlphabetOrDigitOnly:(NSString *)sourceString;

+ (NSString *)md5:(NSString *)sourceString;

@end
