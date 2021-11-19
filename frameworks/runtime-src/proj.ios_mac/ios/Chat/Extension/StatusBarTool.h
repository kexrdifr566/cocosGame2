//
//  NNDeviceInformation.h
//  NNDeviceInformation
//
//  Created by 刘朋坤 on 17/4/7.
//  Copyright © 2017年 刘朋坤. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusBarTool : NSObject
 

/// 获取精准电池电量
+ (CGFloat)getCurrentBatteryLevel;

/// 获取电池当前的状态，共有4种状态
+ (NSString *) getBatteryState;

/// 获取当前语言
+ (NSString *)getDeviceLanguage;

/// WIFI信号强度
+ (int)getSignalStrength;

/// 网络信号类型
+(NSString *)getNetWorkStates;

/// 设备是否允许通知
+(BOOL)isOpenRemoteNotification;

+ (NSString*)convertToJSONData:(id)infoDict;

@end

