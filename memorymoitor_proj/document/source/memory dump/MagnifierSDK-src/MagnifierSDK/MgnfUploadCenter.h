//
//  UploadCenter.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MgnfUploadCenter : NSObject
- (int)uploadDeviceInfo;
- (int)uploadAnalyseFileWithPath:(NSString*)path type:(int)type Desc:(NSString*)desc RelativeKey:(int)relativeKey;

- (int)uploadDeviceInfo_v2;
- (int)uploadAnalyseFileWithPath_v2:(NSString*)path type:(int)type Desc:(NSString*)desc RelativeKey:(int)relativeKey;
@end
