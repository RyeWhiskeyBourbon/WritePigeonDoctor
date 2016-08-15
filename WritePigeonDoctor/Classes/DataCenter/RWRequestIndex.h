//
//  RWRequestIndex.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/6/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#ifndef RWRequestIndex_h
#define RWRequestIndex_h

#ifndef __SERVER_INDEX__
#define __SERVER_INDEX__ @"http://api.zhongyuedu.com/bg/"
#endif

#ifndef __USER_REGISTER__
#define __USER_REGISTER__ __SERVER_INDEX__@"register.php"
#endif

#ifndef __OFFICE_LIST__
#define __OFFICE_LIST__ __SERVER_INDEX__@"ks_list.php"
#endif

#ifndef __USER_LOGIN__
#define __USER_LOGIN__ __SERVER_INDEX__@"login.php"
#endif

#ifndef __USER_INFORMATION__
#define __USER_INFORMATION__ __SERVER_INDEX__@"age.php"
#endif

#ifndef __SEARCH_DOCTOR__
#define __SEARCH_DOCTOR__ __SERVER_INDEX__@"find_doc.php"
#endif

#ifndef __REPLACE_PASSWORD__
#define __REPLACE_PASSWORD__ __SERVER_INDEX__@"change_pwd.php"
#endif


#ifndef __VERIFICATION_CODE__
#define __VERIFICATION_CODE__ @"http://api.zhongyuedu.com/comm/code.php"
#endif

#endif /* RWRequestIndex_h */
