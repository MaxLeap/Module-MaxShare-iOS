//
//  AppDelegate.m
//  MaxShareDemo
//
//  Created by Sun Jin on 16/5/17.
//  Copyright © 2016年 maxleap. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#define MAXLEAP_APPID           @"your_app_id"
#define MAXLEAP_CLIENTKEY       @"your_client_key"

#define WECHAT_APPID            @"your_wechat_appid"
#define WEIBO_APPKEY            @"your_weibo_appkey"
#define QQ_APPID                @"222222"

@interface AppDelegate ()
<
TencentSessionDelegate,
WXApiDelegate,
WeiboSDKDelegate
>

@property (nonatomic, strong) TencentOAuth *tOAuth;

@end

@implementation AppDelegate

#pragma mark -
#pragma mark TencentLoginDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    
}

#pragma mark -
#pragma mark TencentApiInterfaceDelegate

- (BOOL)onTencentResp:(TencentApiResp *)resp {
    
    return NO;
}

#pragma mark -
#pragma mark WXApiDelegate

- (void)onReq:(BaseReq*)req {
    NSLog(@"weixin request: %@", req);
}

- (void)onResp:(BaseResp*)resp {
    // 这里可以获得微信分享的结果
    NSLog(@"weixin response: %@", resp);
}

#pragma mark -
#pragma mark WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    // 这里可以获得微博分享结果
}

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化微博
#if DEBUG
    [WeiboSDK enableDebugMode:YES];
#endif
    [WeiboSDK registerApp:WEIBO_APPKEY];
    
    // 腾讯的初始化是创建一个 TencentOAuth 对象并保存起来，腾讯 SDK 稍后会使用它，也就是说，这个对象会作用于全局。
    self.tOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
    
    // 初始化微信
    [WXApi registerApp:WECHAT_APPID];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL wx = [WXApi handleOpenURL:url delegate:self];
    BOOL qq = [TencentOAuth HandleOpenURL:url];
    BOOL qqApi = qq || [TencentApiInterface handleOpenURL:url delegate:self];
    BOOL wb = [WeiboSDK handleOpenURL:url delegate:self];
    return wx || qq || qqApi || wb;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wx = [WXApi handleOpenURL:url delegate:self];
    BOOL qq = [TencentOAuth HandleOpenURL:url];
    BOOL qqApi = qq || [TencentApiInterface handleOpenURL:url delegate:self];
    BOOL wb = [WeiboSDK handleOpenURL:url delegate:self];
    return wx || qq || qqApi || wb;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
