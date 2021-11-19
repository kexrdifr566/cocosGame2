//
//  NNDeviceInformation.m
//  NNDeviceInformation
//
//  Created by 刘朋坤 on 17/4/7.
//  Copyright © 2017年 刘朋坤. All rights reserved.
//

#import "StatusBarTool.h"
#import "sys/utsname.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <mach/mach.h>
#include <objc/runtime.h>

@implementation StatusBarTool


/// 获取精准电池电量
+ (CGFloat)getCurrentBatteryLevel {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0) {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar) {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

/// 获取电池当前的状态，共有4种状态
+ (NSString *) getBatteryState {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return @"未知";
    } else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return @"未插入";
    } else if (device.batteryState == UIDeviceBatteryStateCharging){
        return @"充电中";
    } else if (device.batteryState == UIDeviceBatteryStateFull){
        return @"充满";
    }
    return nil;
}



/// WIFI信号强度
+ (int)getSignalStrength{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    
    return  signalStrength;
}

/// 网络信号类型
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *dataNetworkItemView = @"";
    NSString *state = @"未知";
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int networkType = [[dataNetworkItemView valueForKey:@"_dataNetworkType"] intValue];
    //获取到网络返回码
    switch (networkType) {
        case 0:
            state = @"无网络";
            //无网模式
            break;
        case 1:
            state =  @"2G";
            break;
        case 2:
            state =  @"3G";
            break;
        case 3:
            state =   @"4G";
            break;
        case 5:
        {
            state =  @"wifi";
            break;
        default:
            break;
        }
    }
    
    return state;
}

/// 设备是否允许通知
+(BOOL)isOpenRemoteNotification{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭 8.0");
            return NO;
        }
        else
        {
            NSLog(@"推送打开 8.0");
            return YES;
        }
    }
    else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
            return NO;
        }
        else
        {
            NSLog(@"推送打开");
            return YES;
        }
    }
}

+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

@end



