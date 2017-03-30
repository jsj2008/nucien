//
//  IODataCenter.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/26.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MgnfFileCache.h"
#import "MgnfUploadCenter.h"


@interface MgnfIODataCenter : NSObject
{
    //当前所有打开的文件列表
    NSMutableDictionary *m_curFileList;
    MgnfFileCache* m_fileCache;
    dispatch_queue_t _serialQueue;
    MgnfUploadCenter* m_uploadCenter;
    BOOL m_bBackup;
    BOOL m_bDebug;
}

- (id)init;

- (void)onHookOpenWithFd:(NSNumber*)fd Path:(NSString*)path ThreadID:(NSNumber*)tid ThreadName:(NSString*)threadName Time:(NSNumber*)time CallStack:(NSArray*)callStack;
- (int)onHookReadWithFd:(NSNumber*)fd Bytes:(NSNumber*)bytes;
- (int)onHookWriteWithFd:(NSNumber*)fd Bytes:(NSNumber*)bytes;
- (int)onHookCloseWithFd:(NSNumber*)fd;

-(void)saveToDiskAndUploadInMainThread;
-(void)saveToDiskAndUploadInSubThread;

- (long)getOpenedFileCount;

//-(void)saveToDisk;

-(void)setBackupMode:(BOOL)bBackup;

-(void)setDebugMode:(BOOL)bDebug;

@end
