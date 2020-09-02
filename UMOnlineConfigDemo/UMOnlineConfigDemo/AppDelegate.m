//
//  AppDelegate.m
//  UMOnlineConfigDemo
//
//  Created by zhangjunhua on 2020/9/1.
//  Copyright © 2020 zhangjunhua. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMRemoteConfig.h>
#import <UMCommon/UMRemoteConfigSettings.h>
#import <UMCommonLog/UMCommonLogHeaders.h>


@interface AppDelegate ()<UMRemoteConfigDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"53ccbaed56240bbd8911b8a2" channel:@"App Store"];
    
    //初始化设置activateAfterFetch = YES 为获取数据后自动激活
    //初始化设置activateAfterFetch = NO 就需要手动激活数据[UMRemoteConfig activateWithCompletionHandler:nil];
    [UMRemoteConfig remoteConfig].remoteConfigDelegate = self;
    [UMRemoteConfig remoteConfig].configSettings.activateAfterFetch = YES;
    
    //设置本地默认的数据，在没有取到服务器的数据的时候，获取本地的数据
    [UMRemoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
    
    //获取的是上一次激活的数据，如果上一次的数据是最新的就直接使用，
    //不然需要在UMRemoteConfigDelegate:remoteConfigActivated的回调里面获取最新值，后续的获取都是最新的值
    NSString* configtestValue =  [UMRemoteConfig configValueForKey:@"configtest"];
    NSLog(@"remoteConfigActivated init configtest = %@",configtestValue);
    
    return YES;
}


//#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

#pragma mark- UMRemoteConfigDelegate

-(void)remoteConfigActivated:(UMRemoteConfigActiveStatus)status
                       error:(nullable NSError*)error
                    userInfo:(nullable id)userInfo{
    if (error) {
        NSLog(@"remoteConfigActivated error:%@",error);
        return;
    }
    
    //回调到这表示当前获取到了服务器的最新的参数
    NSString* configtestValue =  [UMRemoteConfig configValueForKey:@"configtest"];
    NSLog(@"remoteConfigActivated Activated for configtest = %@",configtestValue);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteConfigActivated" object:nil];
}


-(void)remoteConfigReady:(UMRemoteConfigActiveStatus)status
                   error:(nullable NSError*)error
                userInfo:(nullable id)userInfo{
    if (error) {
        NSLog(@"remoteConfigReady error:%@",error);
        return;
    }
    
    //在[UMRemoteConfig remoteConfig].configSettings.activateAfterFetch = NO的时候调用，来选择用以前的缓存的数据还是激活当前下载的服务器最新的数据
    //[UMRemoteConfig activateWithCompletionHandler:nil];
    
}


@end
