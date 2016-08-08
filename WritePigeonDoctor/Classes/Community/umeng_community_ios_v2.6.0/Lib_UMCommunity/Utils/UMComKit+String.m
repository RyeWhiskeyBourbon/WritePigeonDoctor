//
//  UMComKit+String.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit+String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UMComKit (String)

+ (BOOL)checkEmailFormat:(NSString *)emailString
{
    if (emailString.length == 0)
        return NO;
//    NSString *regex = @"[\w-]+(\.[\w-]+)*@([\w-])+((\.\w+)+)";
    NSString *regex = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:emailString];
}

+ (BOOL)includeSpecialCharact:(NSString *)sourceString
{
    NSString *regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = ![pred evaluateWithObject:sourceString];
    return isRight;
}

+ (BOOL)includeAlphabetOrDigitOnly:(NSString *)sourceString
{
    NSString *regex = @"(^[a-zA-Z0-9]+$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = [pred evaluateWithObject:sourceString];
    return isRight;
}

+ (NSString *)md5:(NSString *)sourceString
{
    const char *cStr = [sourceString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [str appendFormat:@"%02X", result[i]];
    }
    return str.lowercaseString;
}

@end
