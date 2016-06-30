//
//  AppDelegate+FCPushNotification.m
//  FCNotificationSample
//
//  Created by viziner on 16/6/30.
//  Copyright © 2016年 viziner. All rights reserved.
//

#import "AppDelegate+FCPushNotification.h"

@implementation AppDelegate (FCPushNotification)
- (void)fc_registerPushNotification{
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                 categories:[NSSet setWithObjects:[AppDelegate getPushNotificationCategory1],
                                                                                             [AppDelegate getiOS9ReplyTextPushNotificationCategory1], nil]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        UIRemoteNotificationType type = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
#endif
    }
    
}

+ (UIMutableUserNotificationCategory *)getPushNotificationCategory1{
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1";
    action1.title = @"进入前台";
    action1.activationMode = UIUserNotificationActivationModeForeground;//进入到前台
    action1.destructive = YES;
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title = @"后台捣鼓";
    action2.activationMode = UIUserNotificationActivationModeBackground;
    action2.authenticationRequired = NO;
    action2.destructive = NO;
    
    UIMutableUserNotificationCategory *category1 = [[UIMutableUserNotificationCategory alloc] init];
    category1.identifier = @"Category1";
    [category1 setActions:@[action2,action1] forContext:UIUserNotificationActionContextDefault];
    
    return category1;
}

+ (UIMutableUserNotificationCategory *)getiOS9ReplyTextPushNotificationCategory1{
    
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1";
    action1.title = @"懒得鸟你";
    action1.activationMode = UIUserNotificationActivationModeBackground;
    action1.authenticationRequired = NO;
    action1.destructive = NO;

    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title = @"装完13还想跑";
    action2.activationMode = UIUserNotificationActivationModeBackground;//后台执行
    action2.destructive = NO;
    /*
     destructive 破坏性->锁屏界面,背景颜色
     YES 红色
     YES YES 红色 红色
     NO NO 灰 蓝
     YES NO 红 蓝
     
     */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
        action2.authenticationRequired = YES;//是否需要解锁(锁屏界面),比如收藏等操作可以不需要解锁,直接后台进行操作就可以了,但是回复文本时,由于键盘无法显示,所以需要解锁.
        action2.behavior = UIUserNotificationActionBehaviorTextInput;
        action2.parameters = @{
                               UIUserNotificationTextInputActionButtonTitleKey:@"等着,叫人呢!"
                               };
    }
    
    UIMutableUserNotificationCategory *category1 = [[UIMutableUserNotificationCategory alloc] init];
    category1.identifier = @"Category2";
    [category1 setActions:@[action2,action1] forContext:UIUserNotificationActionContextDefault];
    
    return category1;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"register remote notification error = %@",error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"device token = %@",deviceTokenStr);
    
    UIPasteboard *paseteBoard = [UIPasteboard generalPasteboard];
    [paseteBoard setString:deviceTokenStr];
}


//iOS7以前接收推送方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remote notification = %@",userInfo);
}
//iOS7 开始接受推送方法,包括后台接收
//后台执行(kill后,无法调用),payload中的aps中添加字段:content-available => 1
//同时需要对info.plist进行配置:添加Key:UIBackgroundModes(数组),添加object:remote-notification 或 Target->capabilities->Background Modes 选择

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"remote notification = %@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);

}
//通知上按钮动作
//通知提示上,添加动作,payload中的aps中添加字段:key:category value:注册category时,identifier
//App kill,进行文本回复等操作过程,其实app类似于处于后台状态
//iOS8
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"remote notification identifier = %@",identifier);
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS9
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    [[NSUserDefaults standardUserDefaults] setObject:responseInfo[UIUserNotificationActionResponseTypedTextKey] forKey:identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"remote notification identifier = %@ \n responseInfo = %@",identifier,responseInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}


@end
