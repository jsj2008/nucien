//
//  DeviceInfo.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface MgnfDeviceInfo : NSObject

//获取手机uuid
+ (NSString*)getDeviceId;
//获取手机型号,如iPhone 6 Plus
+ (NSString*)getFirma;
//获取操作系统
+ (NSString*)getOperationSys;
//获取分辨率
+ (CGSize)getResolution;
//获取内存大小M
+ (int)getInnerStorage;
//获取外存大小G
+ (int)getOuterStorage;
//获取最大堆内存
+ (int)getMaxMemoryHeap;
//是否越狱
+ (BOOL)isRooted;
//平台
+ (NSString*)getPlatform;
//设备用途
//1:android monkey
//2:android功能自动化
//3:android手工测试
//4:ios monkey
//5:ios功能自动化
//6:ios手工测试
+ (NSString*)getDeviceUseFor;
//设备类型
//0：未知类型
//1：android
//2：ios
//3：android pad
//4:ipad
+ (int)getDeviceType;
@end
