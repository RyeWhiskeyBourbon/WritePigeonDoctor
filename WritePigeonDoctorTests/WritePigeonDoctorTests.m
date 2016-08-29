//
//  WritePigeonDoctorTests.m
//  WritePigeonDoctorTests
//
//  Created by zhongyu on 16/7/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWRequsetManager+UserLogin.h"
#import "RWDataBaseManager+ChatCache.h"
#import "XZUMComPullRequest.h"
#import "UMComUser.h"
#import "UMComSession.h"
#import "UMComImageUrl.h"
#import "UMComMacroConfig.h"
#import "RWDataBaseManager.h"
#import "RWOrderView.h"

@interface WritePigeonDoctorTests : XCTestCase

<
    RWRequsetDelegate
>

@end

@implementation WritePigeonDoctorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testLogin
{
    RWRequsetManager *requsetManager = [[RWRequsetManager alloc] init];
    requsetManager.delegate = self;
    
    [requsetManager userinfoWithUsername:@"18562599337" AndPassword:@"qwertyu"];

    CFRunLoopRun();
}

- (void)userLoginSuccess:(BOOL)success responseMessage:(NSString *)responseMessage
{
    XCTAssertTrue(success);
    
    CFRunLoopRef ref = CFRunLoopGetCurrent();
    CFRunLoopStop(ref);
}


- (void)testBulidOrder
{
    RWServiceDetail *detail = [[RWServiceDetail alloc] init];
    
    detail.name = @"RyeWhiskey";
    detail.contactWay = @"18562599337";
    detail.date = @"2016-8-30";
    detail.province = @"山东省";
    detail.hospital = @"青医附院";
    detail.office = @"精神科";
    detail.address = @"青岛市市北区江苏路100号";
    detail.doctor = @"马医生";
    detail.comments = @"精神分裂";
    detail.serviceType = @(RWServiceTypeAccompanyTreat);
    detail.serviceSite = @(RWServiceSiteInHospital);
    
    RWOrder *order = [RWOrder appointmentOrderWithUserName:@"18562599337" servicedescription:detail];
    
    RWRequsetManager *requsetManager = [[RWRequsetManager alloc] init];
    requsetManager.delegate = self;
    
    [requsetManager bulidOrderWith:order];
    
    CFRunLoopRun();
}

- (void)orderReceipt:(RWOrder *)order responseMessage:(NSString *)responseMessage
{
    XCTAssertNotNil(order);
    
    CFRunLoopRef ref = CFRunLoopGetCurrent();
    CFRunLoopStop(ref);
}

- (void)testService
{
    RWServiceDetail *detail = [[RWServiceDetail alloc] init];
    
    detail.name = @"RyeWhiskey";
    detail.contactWay = @"18562599337";
    detail.date = @"2016-8-30";
    detail.province = @"山东省";
    detail.hospital = @"青医附院";
    detail.office = @"精神科";
    detail.address = @"青岛市市北区江苏路100号";
    detail.doctor = @"马医生";
    detail.comments = @"精神分裂";
    detail.serviceType = @(RWServiceTypeAccompanyTreat);
    detail.serviceSite = @(RWServiceSiteInHospital);
    
    NSLog(@"%@",detail.description);
    
    RWServiceDetail *de = [RWServiceDetail serviceDetailWithDescription:detail.description];
    
    NSLog(@"%@",de.description);
}

- (void)testOffice
{
    RWRequsetManager *manager = [[RWRequsetManager alloc] init];
    
    [manager obtainOfficeDoctorListWithURL:@"http://api.zhongyuedu.com/bg/ks/list_ebh.php" page:1];
    
    CFRunLoopRun();
}

- (void)testRegister
{
    RWRequsetManager *manager = [[RWRequsetManager alloc] init];
    
    [manager registerWithUsername:@"iOSTest002"
                      AndPassword:@"iOSTest002"
                 verificationCode:@""];
    
    
//    [manager userinfoWithUsername:@"12345678121" AndPassword:@"123"];
    
    CFRunLoopRun();
}

- (void)testAddUser
{
    RWDataBaseManager *defaultManager = [RWDataBaseManager defaultManager];
    
    RWUser *user = [[RWUser alloc] init];
    
    user.username = @"12345678910";
    user.password = @"123456";
    user.age = @"30";
    user.gender = @"男";
    user.header = nil;
    user.name = @"new";
    
    XCTAssertTrue([defaultManager addNewUesr:user]);
    XCTAssertTrue([defaultManager existUser:user.username]);
    
    RWUser *defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNotNil(defaultUser);
    
    NSLog(@"username = %@ \n password = %@ \n age = %@ gender = %@ \n header = %@ \n name = %@ \n defaultUser = %d",  defaultUser.username,
          defaultUser.password,
          defaultUser.age,
          defaultUser.gender,
          defaultUser.header,
          defaultUser.name,
          defaultUser.defaultUser);
    
    user.username = @"12345678910";
    user.password = @"123456";
    user.age = @"21";
    user.gender = @"woman";
    user.header = nil;
    user.name = @"heooo";
    user.defaultUser = YES;
    
    XCTAssertTrue([defaultManager updateUesr:user]);
    
    defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNotNil(defaultUser);
    
    NSLog(@"username = %@ \n password = %@ \n age = %@ gender = %@ \n header = %@ \n name = %@ \n defaultUser = %d",  defaultUser.username,
          defaultUser.password,
          defaultUser.age,
          defaultUser.gender,
          defaultUser.header,
          defaultUser.name,
          defaultUser.defaultUser);
    
}

- (void)testChangeSettings
{
    RWDataBaseManager *defaultManager = [RWDataBaseManager defaultManager];
    
    XCTAssertTrue([defaultManager removeUser:[defaultManager getDefualtUser]]);
    
    RWUser *defaultUser = [defaultManager getDefualtUser];
    
    XCTAssertNil(defaultUser);
}

- (void)testDoctorRegister
{
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *username = @"18562599324";
    NSString *password = @"qwertyu";
//    NSString *yzm = @"";
    NSString *nickname = @"李医生";
    NSString *hos = @"新潮未来科技医院";
    NSString *groupid = @"24";
    NSString *notice = @"暂无";
    NSString *title = @"主任医师";
    
    [XZUMComPullRequest userCustomAccountLoginWithName:username
                                              sourceId:username
                                              icon_url:nil
                                                gender:0
                                                   age:0
                                                custom:nil
                                                 score:0
                                            levelTitle:nil
                                                 level:0
                                     contextDictionary:nil
                                          userNameType:userNameDefault
                                        userNameLength:userNameLengthDefault
                                            completion:^(NSDictionary *responseObject, NSError *error)
     {
         XCTAssertNil(error);
         
         if(!error)
         {
             UMComUser *umuser = responseObject[UMComModelDataKey];
             
             NSDictionary *body = @{@"username":username,
                                    @"password":password,
                                    @"udid":[UIDevice currentDevice].identifierForVendor.UUIDString,
//                                    @"yzm":yzm,
                                    @"umid":umuser.uid,
                                    @"nickname":nickname,
                                    @"hos":hos,
                                    @"groupid":groupid,
                                    @"notice":notice,
                                    @"title":title};
             
             [requestManager POST:@"http://api.zhongyuedu.com/bg/register_doc.php"
                            parameters:body
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
              {
                  NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                  
                  NSLog(@"%@",Json);
                  
                  XCTAssertTrue([[Json objectForKey:@"resultCode"] integerValue] == 200);
                  
                  
                  
                  CFRunLoopRef ref = CFRunLoopGetCurrent();
                  CFRunLoopStop(ref);
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
              {
                  XCTAssertThrows(error.description);
                  CFRunLoopRef ref = CFRunLoopGetCurrent();
                  CFRunLoopStop(ref);
              }];
         }
         else
         {
             CFRunLoopRef ref = CFRunLoopGetCurrent();
             CFRunLoopStop(ref);
         }
     }];
    
    CFRunLoopRun();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
