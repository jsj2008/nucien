//
//  IODataCenter.m
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/26.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import "MgnfIODataCenter.h"
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>
#import "MgnfLogger.h"
#import <objc/runtime.h>
#import "ImageInfo.h"

static OSSpinLock fdDictLock = OS_SPINLOCK_INIT;
@implementation MgnfIODataCenter
 
- (id)init
{
    if (self = [super init]){
        m_bDebug = NO;
        m_bBackup = NO;
        m_curFileList = [NSMutableDictionary dictionaryWithCapacity:0];
        m_fileCache = [[MgnfFileCache alloc]initWithType:0];
        m_uploadCenter = [[MgnfUploadCenter alloc]init];
        //创建写线程串行队列
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
        //上传设备信息
//        dispatch_async(_serialQueue, ^{
//            DLog(@"upload device info,ret:%d",[m_uploadCenter uploadDeviceInfo]);
//        });
        DLog(@"upload device info,ret:%d",[m_uploadCenter uploadDeviceInfo_v2]);
    }
    return self;
}

-(void)setBackupMode:(BOOL)bBackup
{
    m_bBackup = bBackup;
}

-(void)setDebugMode:(BOOL)bDebug
{
    m_bDebug = bDebug;
}

- (void)onHookOpenWithFd:(NSNumber*)fd Path:(NSString*)path ThreadID:(NSNumber*)tid ThreadName:(NSString*)threadName Time:(NSNumber*)time CallStack:(NSArray*)callStack
{
    //屏蔽掉IOMonitor本身的文件监控
    NSRange range;
    range = [path rangeOfString:@"iomonitor"];
    if (range.location!=NSNotFound) {
        return;
    }
//    DLog(@"opentime:%@",time);
    NSMutableDictionary* record = [NSMutableDictionary dictionaryWithCapacity:9];
    [record setObject:fd forKey:@"fd"];
    [record setObject:path forKey:@"path"];
    [record setObject:tid forKey:@"threadID"];
    [record setObject:threadName forKey:@"threadName"];
    [record setObject:time forKey:@"openTime"];
    [record setObject:callStack forKey:@"stack"];
    [record setObject:[NSNumber numberWithLong:0] forKey:@"readCount"];
    [record setObject:[NSNumber numberWithLong:0] forKey:@"readBytes"];
    [record setObject:[NSNumber numberWithLong:0] forKey:@"writeCount"];
    [record setObject:[NSNumber numberWithLong:0] forKey:@"writeBytes"];
    
    OSSpinLockLock(&fdDictLock);
    [m_curFileList setObject:record forKey:fd];
    OSSpinLockUnlock(&fdDictLock);
    
    
}

- (int)onHookReadWithFd:(NSNumber*)fd Bytes:(NSNumber*)bytes
{
    NSMutableDictionary *record = [m_curFileList objectForKey:fd];
    //未找到记录
    if (record == nil) {
        return 1;
    }
    NSNumber *readCount = [record objectForKey:@"readCount"];
    NSNumber *readBytes = [record objectForKey:@"readBytes"];
    long rc = [readCount longValue] + 1;
    long rb = [readBytes longValue] + [bytes longValue];
    [record setObject:[NSNumber numberWithLong:rc] forKey:@"readCount"];
    [record setObject:[NSNumber numberWithLong:rb] forKey:@"readBytes"];
    OSSpinLockLock(&fdDictLock);
    [m_curFileList setObject:record forKey:fd];
    OSSpinLockUnlock(&fdDictLock);
    
    return 0;
    
}

- (int)onHookWriteWithFd:(NSNumber*)fd Bytes:(NSNumber*)bytes
{
    NSMutableDictionary *record = [m_curFileList objectForKey:fd];
    //未找到记录
    if (record == nil) {
        return 1;
    }
    NSNumber *writeCount = [record objectForKey:@"writeCount"];
    NSNumber *writeBytes = [record objectForKey:@"writeBytes"];
    long wc = [writeCount longValue] + 1;
    long wb = [writeBytes longValue] + [bytes longValue];
    [record setObject:[NSNumber numberWithLong:wc] forKey:@"writeCount"];
    [record setObject:[NSNumber numberWithLong:wb] forKey:@"writeBytes"];
    OSSpinLockLock(&fdDictLock);
    [m_curFileList setObject:record forKey:fd];
    OSSpinLockUnlock(&fdDictLock);
    return 0;
}

- (int)onHookCloseWithFd:(NSNumber*)fd
{
    NSMutableDictionary *record = [m_curFileList objectForKey:fd];
    //未找到记录
    if (record == nil) {
        return 1;
    }
    OSSpinLockLock(&fdDictLock);
    [m_curFileList removeObjectForKey:fd];
    OSSpinLockUnlock(&fdDictLock);
    NSNumber* openTime = [record objectForKey:@"openTime"];
    double consume = (CFAbsoluteTimeGetCurrent() - [openTime doubleValue])*1000;
    [record setObject:[NSNumber numberWithDouble:consume] forKey:@"consume"];
    
    [self onFinishedClose:record];
    return 0;
}



- (void)addToCache:(NSDictionary*)item
{
    NSNumber* fd = [item objectForKey:@"fd"];
    NSNumber* openTime = [item objectForKey:@"openTime"];
    NSString* path = [item objectForKey:@"path"];
    NSArray *stack = [item objectForKey:@"stack"];
    NSNumber* tid = [item objectForKey:@"threadID"];
    NSString *tname = [item objectForKey:@"threadName"];
    NSNumber *readCount = [item objectForKey:@"readCount"];
    NSNumber *readBytes = [item objectForKey:@"readBytes"];
    NSNumber *writeCount = [item objectForKey:@"writeCount"];
    NSNumber *writeBytes = [item objectForKey:@"writeBytes"];
    double consume = [[item objectForKey:@"consume"] doubleValue];
    double writetime = 0.0;
    double readtime  = 0.0;
    if ([readCount longValue] > 0) {
        readtime = consume;
    }
    else {
        writetime = consume;
    }
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    //QQ bundleID 重定向为com.tencent.mqq
    if ([bundleID isEqualToString:@"com.tencent.qq.dailybuild"]||
        [bundleID isEqualToString:@"com.tencent.qq.dailybuild.vip"]||
        [bundleID isEqualToString:@"com.tencent.qq.dailybuild.test.zx"]) {
        bundleID = @"com.tencent.mqq";
    }
    //QQ音乐重定向 com.tencent.qqmusic
    if ([bundleID isEqualToString:@"com.tencent.QQMusic.dailybuild"]||
        [bundleID isEqualToString:@"com.tencent.QQMusic"]||
        [bundleID isEqualToString:@"com.tencent.sng.test.gn"]||
        [bundleID isEqualToString:@"com.tencent.sng.test.zx"]) {
        bundleID = @"com.tencent.qqmusic";
    }
    
    NSString* output;
    if (m_bDebug)
    {
//        output = [NSString stringWithFormat:@"%@,%f,%@,%@,%@,%@,%@,%@,%.1f,%@,%@,%.1f,%@\n",fd,[openTime doubleValue],path, [[NSBundle mainBundle] bundleIdentifier],tid,tname, readCount, readBytes, readtime, writeCount, writeBytes, writetime,[self getDesOfArray:stack]];
        output = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%.1f,%@,%@,%.1f,%@\n",path,bundleID,tname, readCount, readBytes, readtime, writeCount, writeBytes, writetime,[self getDesOfArray:stack]];
    }
    else
    {
//        output = [NSString stringWithFormat:@"%@,%f,%@,%@,%@,%@,%@,%@,%.1f,%@,%@,%.1f,%@\n",fd,[openTime doubleValue],path, [[NSBundle mainBundle] bundleIdentifier],tid,tname, readCount, readBytes, readtime, writeCount, writeBytes, writetime,[self getDesOfArray:[ImageInfo getStackInfo:stack]]];
        output = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%.1f,%@,%@,%.1f,%@\n",path, bundleID,tname, readCount, readBytes, readtime, writeCount, writeBytes, writetime,[self getDesOfArray:[ImageInfo getStackInfo:stack]]];
    }
   
    [m_fileCache addItem:output];
}



//满足1w条则上传

- (void)onFinishedClose:(NSDictionary*)item
{

    dispatch_async(_serialQueue, ^{
        [self addToCache:item];
        if ([m_fileCache count]>=10000) {
            [self saveToDiskAndUploadInSubThread];
        }
        
    });
    
    
}


//主线程调用
-(void)saveToDiskAndUploadInMainThread
{
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
        UIApplication* app = [UIApplication sharedApplication];
        __block  UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            if (bgTask!=UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
            
        }];
        dispatch_async(_serialQueue, ^{
            if (bgTask!=UIBackgroundTaskInvalid) {
                [self _writeToDiskAndUpload];
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });

        
    }
    else
    {
        dispatch_async(_serialQueue, ^{
            [self _writeToDiskAndUpload];
        });
    }
}

//子线程调用
-(void)saveToDiskAndUploadInSubThread
{
    
    //如果处于后台 只能在主线程做如下事情
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIApplication* app = [UIApplication sharedApplication];
            __block  UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
                if (bgTask!=UIBackgroundTaskInvalid) {
                    [app endBackgroundTask:bgTask];
                    bgTask = UIBackgroundTaskInvalid;
                }
                
            }];
            dispatch_async(_serialQueue, ^{
                if (bgTask!=UIBackgroundTaskInvalid) {
                    [self _writeToDiskAndUpload];
                    [app endBackgroundTask:bgTask];
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
            
        });
    }
    else
    {
        [self _writeToDiskAndUpload];
    }
}

-(void)_writeToDiskAndUpload
{
    if([m_fileCache count]>0)
    {
        NSString* path = [m_fileCache writeToDisk];
        int ret = [m_uploadCenter uploadAnalyseFileWithPath:path type:10 Desc:@"" RelativeKey:0];
//        int ret = [m_uploadCenter uploadAnalyseFileWithPath_v2:path type:10 Desc:@"" RelativeKey:0];
        DLog(@"upload file %@,ret:%d",path,ret);
        
        if (m_bBackup) {
            return;
        }
        //上传成功，则删除本地备份文件
        if (ret==0) {
            DLog(@"Delete the local file");
            NSFileManager* fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:path]){
                [fileManager removeItemAtPath:path error:nil];
            }
            
        }
        
        
    }
}


-(NSString*)getDesOfArray:(NSArray*)array {
    NSString* description = [NSString stringWithFormat:@"\""];
    for (id item in array) {
        description = [description stringByAppendingFormat:@"%@->", item];
    }
    description = [description stringByAppendingFormat:@"\""];
    
    return description;
}

//
//-(NSString*)getDesOfArray:(NSArray*)array {
//    NSString* description = [NSString stringWithFormat:@"\"(\n"];
//    for (id item in array) {
//        description = [description stringByAppendingFormat:@"%@\n", item];
//    }
//    description = [description stringByAppendingFormat:@")\""];
//
//    return description;
//}

- (long)getOpenedFileCount
{
    return [m_curFileList count];
}




@end