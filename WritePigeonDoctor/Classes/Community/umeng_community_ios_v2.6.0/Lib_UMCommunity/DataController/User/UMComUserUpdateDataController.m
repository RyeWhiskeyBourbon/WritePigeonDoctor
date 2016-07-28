//
//  UMComUserUpdateDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserUpdateDataController.h"
#import "UMComDataRequestManager.h"
#import "UMComSession.h"
#import "UMComUser.h"
#import "UMComDataBaseManager.h"
#import "UMComMacroConfig.h"
#import "UMComImageUrl.h"

@implementation UMComUserUpdateDataController


- (void)updateAvatarWithImage:(id)image
                   completion:(UMComDataRequestCompletion)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UMComDataRequestManager defaultManager] userUpdateAvatarWithImage:image completion:^(NSDictionary *responseObject, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (!error) {
            UMComCreatorIconUrl *imageUrl = responseObject[UMComModelDataKey];
            if (imageUrl && [UMComSession sharedInstance].loginUser) {
                [UMComSession sharedInstance].loginUser.icon_url = imageUrl;
                
                NSLog(@"new >> 1 %@", [UMComSession sharedInstance].loginUser.icon_url.image_url_id);

                [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[[UMComSession sharedInstance].loginUser]];
                
                NSLog(@"after save >> 2 %@", [UMComSession sharedInstance].loginUser.icon_url.image_url_id);

//                NSArray* loginUserArray = [[UMComDataBaseManager shareManager] fetchSyncUMComUserWithType:UMComRelatedRegisterUserID];
                NSLog(@">>after read 3 %@", [UMComSession sharedInstance].loginUser.icon_url.image_url_id);
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateAvatarSucceedNotification object:image];
        }
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComDataRequestCompletion)completion
{
    
    [[UMComDataRequestManager defaultManager] updateProfileWithName:name age:age gender:gender custom:custom userNameType:userNameDefault userNameLength:userNameLengthDefault completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            UMComUser *user = [UMComSession sharedInstance].loginUser;
            if (name) {
                user.name = name;
            }
            if (age) {
                user.age = age;
            }
            if (gender) {
                user.gender = gender;
            }
            [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[user]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateProfileSucceedNotification object:nil];
        }
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

@end
