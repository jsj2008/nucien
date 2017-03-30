//
//  Logger.h
//  MagnifierSDK
//
//  Created by kirk on 15/8/11.
//  Copyright (c) 2015年 tencent. All rights reserved.
//


//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s:%d||" fmt), __FILE__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif
#import <Foundation/Foundation.h>
NSString * DDExtractFileNameWithoutExtension(const char *filePath, BOOL copy);
#define THIS_FILE    (DDExtractFileNameWithoutExtension(__FILE__, NO))
#define DLog(fmt, ...) NSLog((@"%@:%d||" fmt), THIS_FILE, __LINE__, ##__VA_ARGS__);

//#define DEBUG_INFO  1