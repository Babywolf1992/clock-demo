//
//  Contants.h
//  zdnz
//
//  Created by babywolf on 15/12/22.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//


#import "UIViewExt.h"
#import "NSArray+Log.h"
#import "NSArray+Log.h"

#define kDebug 1

#if kDebug == 1
#define kBaseURL @"http://192.168.10.16:4000"
#else
#define kBaseURL @"http://192.168.10.16:3000"
#endif

// tenect Oauth
#define PreDefM_APPID @"1105081035"

// sina Oauth
#define kSINA_AppKey @"327462439"
#define kSINA_RedirectURI @"https://api.weibo.com/oauth2/default.html"

// url地址
#define kBaseImageURL @"http://7xohfg.com1.z0.glb.clouddn.com/"

#define kGetImageToken [NSString stringWithFormat:@"%@/service/users/updateImage",kBaseURL]

#define kRegisterURL [NSString stringWithFormat:@"%@/service/users/register",kBaseURL]
#define kLoginURL [NSString stringWithFormat:@"%@/service/users/login",kBaseURL]

#define kAddAlarmURL [NSString stringWithFormat:@"%@/service/event/addAlarm",kBaseURL]
#define kAddMeetingURL [NSString stringWithFormat:@"%@/service/event/addMeeting",kBaseURL]
#define kAddAnnURL [NSString stringWithFormat:@"%@/service/event/addAnniversary",kBaseURL]

#define kGetAlarmURL [NSString stringWithFormat:@"%@/service/event/getAlarm",kBaseURL]
#define kGetMeetingURL [NSString stringWithFormat:@"%@/service/event/getMeeting",kBaseURL]
#define kGetAnnURL [NSString stringWithFormat:@"%@/service/event/getAnniversary",kBaseURL]

#define kGetTodayDataURL [NSString stringWithFormat:@"%@/service/event/getSchedulesByDate",kBaseURL]

#define kDeleteAlarmURL [NSString stringWithFormat:@"%@/service/event/deleteAlarm",kBaseURL]
#define kDeleteMeetingURL [NSString stringWithFormat:@"%@/service/event/deleteMeeting",kBaseURL]
#define kDeleteAnnURL [NSString stringWithFormat:@"%@/service/event/deleteAnniversary",kBaseURL]

#define kModifyAlarmURL [NSString stringWithFormat:@"%@/service/event/updateAlarm",kBaseURL]
#define kModifyMeetingURL [NSString stringWithFormat:@"%@/service/event/updateMeeting",kBaseURL]
#define kModifyAnnURL [NSString stringWithFormat:@"%@/service/event/updateAnniversary",kBaseURL]

#define kModifyUserURL [NSString stringWithFormat:@"%@/service/users/updateUser",kBaseURL]

