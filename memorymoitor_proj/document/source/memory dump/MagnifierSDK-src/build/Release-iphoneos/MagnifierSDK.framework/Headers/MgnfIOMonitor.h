//
//  IOMonitor.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/23.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MgnfIOMonitor : NSObject
+(void)startMonitor;
+(void)stopMonitor;
//默认为不备份
+(void)setBackupMode:(BOOL)bBackup;
//默认为Release版本
+(void)setDebugMode:(BOOL)bDebug;
@end
