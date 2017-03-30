//
//  UploadCenter.m
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/20.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "MgnfUploadCenter.h"
#import "MgnfDeviceInfo.h"
#import "MgnfZipArchive.h"
#import "MgnfLogger.h"
#import "AFNetworking/AFNetworking.h"

#define TIMEOUT 10

@implementation MgnfUploadCenter

- (id)init {
    if (self ==[super init]){
    }
    return self;
}

-(int)uploadDeviceInfo_v2
{
    CGSize size = [MgnfDeviceInfo getResolution];
    NSString* strSize= [NSString stringWithFormat:@"%d*%d",(int)size.width,(int)size.height];
    
    NSDictionary *parameters = @{@"username":@"JLLLCKCOAODOBJFK",
                                 @"password":@"ALFLMLILPLBJFK",
                                 @"deviceId":[MgnfDeviceInfo getDeviceId],
                                 @"firma":[MgnfDeviceInfo getFirma],
                                 @"operationSys":[MgnfDeviceInfo getOperationSys],
                                 @"resolution":strSize,
                                 @"innerStorage":[NSString stringWithFormat:@"%d",[MgnfDeviceInfo getInnerStorage]],
                                 @"outerStorage":[NSString stringWithFormat:@"%d",[MgnfDeviceInfo getOuterStorage]],
                                 @"maxMemoryHeap":[NSString stringWithFormat:@"%d",[MgnfDeviceInfo getMaxMemoryHeap]],
                                 @"isRooted":[MgnfDeviceInfo isRooted]?@"yes":@"no",
                                 @"platform":[MgnfDeviceInfo getPlatform],
                                 @"deviceType":[NSString stringWithFormat:@"%d",[MgnfDeviceInfo getDeviceType]]};
    
    
    AFHTTPSessionManager* sessionMgr = [AFHTTPSessionManager manager];
    sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    [sessionMgr POST:@"http://magnifier.tencent.com/v3/mobile/deviceUpload/" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"upload device response:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"upload device error:%@",error);
    }];
    return 0;
}

- (int)uploadDeviceInfo
{
    NSMutableString* str = [[NSMutableString alloc]init];
    [str appendFormat:@"username=%@&",@"JLLLCKCOAODOBJFK"];
    [str appendFormat:@"password=%@&",@"ALFLMLILPLBJFK"];
    [str appendFormat:@"deviceId=%@&",[MgnfDeviceInfo getDeviceId]];
    [str appendFormat:@"firma=%@&",[MgnfDeviceInfo getFirma]];
    [str appendFormat:@"operationSys=%@&",[MgnfDeviceInfo getOperationSys]];
    CGSize size = [MgnfDeviceInfo getResolution];
    NSString* strSize= [NSString stringWithFormat:@"%d*%d",(int)size.width,(int)size.height];
    [str appendFormat:@"resolution=%@&",strSize];
    [str appendFormat:@"innerStorage=%d&",[MgnfDeviceInfo getInnerStorage]];
    [str appendFormat:@"outerStorage=%d&",[MgnfDeviceInfo getOuterStorage]];
    [str appendFormat:@"maxMemoryHeap=%d&",[MgnfDeviceInfo getMaxMemoryHeap]];
    NSString* strRoot = @"no";
    if ([MgnfDeviceInfo isRooted]) {
        strRoot = @"yes";
    }
    [str appendFormat:@"isRooted=%@&",strRoot];  //yes or no
    [str appendFormat:@"platform=%@&",[MgnfDeviceInfo getPlatform]];
    [str appendFormat:@"deviceType=%d",[MgnfDeviceInfo getDeviceType]];

    NSData* postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:@"http://magnifier.tencent.com/v3/mobile/deviceUpload/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:TIMEOUT];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString* strLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setValue: strLength forHTTPHeaderField:@"Content-Length"];
    
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    DLog(@"====================================begin to upload device info==================================================");
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    DLog(@"==================================== upload device info finished==================================================");
    //网络连接错误
    if (error!=nil) {
        DLog(@"error code:%ld",error.code);
        return (int)error.code;
    }
    //返回状态码
    if(response.statusCode!=200)
    {
        DLog(@"status code:%ld",response.statusCode);
        return (int)response.statusCode;
    }
    
    NSDictionary* retDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DLog(@"retDic:%@",retDic);
    //解析返回字符串
    if ([retDic[@"result"] isEqualToString:@"ok"]) {
        return 0;
    }
    NSString* retDatas = retDic[@"datas"];
    NSArray* errorStr = [NSArray arrayWithObjects:
                         @"notSystemUser",
                         @"assetsNumHasIllegalStr",
                         @"deviceIdHasIllegalStr",
                         @"firmaHasIllegalStr",
                         @"operationSysHasIllegalStr",
                         @"resolutionHasIllegalStr",
                         @"isRootedHasIllegalStr",
                         @"deviceUserHasIllegalStr",
                         @"whoUpdateHasIllegalStr",
                         @"deviceUseForHasIllegalStr",
                         @"factoryHasIllegalStr",
                         @"productHasIllegalStr",
                         @"cpunameHasIllegalStr",
                         @"xingeDeviceTokenHasIllegalStr",
                         @"occureException",nil];
    int index = (int)[errorStr indexOfObject:retDatas];
    return (index+1);
}


- (int)uploadAnalyseFileWithPath_v2:(NSString*)path type:(int)type Desc:(NSString*)desc RelativeKey:(int)relativeKey
{
    //检查文件是否存在
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]){
        return 1;
    }
    //拼接压缩文件的路径
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location==NSNotFound) {
        return 2;
    }
    NSString* dir = [path substringToIndex:range.location+1];
    NSString* fileName = [path substringFromIndex:range.location+1];
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    curTime = curTime*1000;
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
    
    
    fileName = [NSString stringWithFormat:@"%.f=%@@%d@%@",curTime,bundleID,type,fileName];
    range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        fileName = [fileName substringToIndex:range.location];
    }
    
    //压缩文件
    NSString* zippedPath = [dir stringByAppendingFormat:@"%@.zip",fileName];
    NSArray* inputPaths = @[path];
    [MgnfZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];
    NSData* fileData=[NSData dataWithContentsOfFile:zippedPath];
    
    NSString* zipFileName = [fileName stringByAppendingString:@".zip"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://magnifier.tencent.com/v3/mobile/uploadFile/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[@"JLLLCKCOAODOBJFK" dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
        [formData appendPartWithFormData:[@"ALFLMLILPLBJFK" dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFormData:[[MgnfDeviceInfo getDeviceId] dataUsingEncoding:NSUTF8StringEncoding] name:@"deviceId"];
        [formData appendPartWithFormData:[@"6.3.0.0" dataUsingEncoding:NSUTF8StringEncoding] name:@"versionName"];
        [formData appendPartWithFileData:fileData name:fileName fileName:zipFileName mimeType:@"application/octet-stream"];
    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          DLog(@"upload file error: %@", error);
                      } else {
                          DLog(@"upload file response:%@",responseObject);
                      }
                  }];
    
    [uploadTask resume];
    DLog(@"====================================begin to upload file==================================================");
    
    return 0;
}


- (int)uploadAnalyseFileWithPath:(NSString*)path type:(int)type Desc:(NSString*)desc RelativeKey:(int)relativeKey
{
    //检查文件是否存在
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]){
        return 1;
    }
    //拼接压缩文件的路径
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location==NSNotFound) {
        return 2;
    }
    NSString* dir = [path substringToIndex:range.location+1];
    NSString* fileName = [path substringFromIndex:range.location+1];
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    curTime = curTime*1000;
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
    
    
    fileName = [NSString stringWithFormat:@"%.f=%@@%d@%@",curTime,bundleID,type,fileName];
    range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location!=NSNotFound) {
        fileName = [fileName substringToIndex:range.location];
    }
    
    //压缩文件
    NSString* zippedPath = [dir stringByAppendingFormat:@"%@.zip",fileName];
    NSArray* inputPaths = @[path];
    [MgnfZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];

    //http上传
    NSURL* url = [NSURL URLWithString:@"http://magnifier.tencent.com/v3/mobile/uploadFile/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    int t = (int)time(NULL);
    
    NSString *boundary = [NSString stringWithFormat:@"--------%d", t];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    //上传表格
    NSMutableDictionary* dictionay = [NSMutableDictionary dictionaryWithCapacity:4];
    [dictionay setObject:@"JLLLCKCOAODOBJFK" forKey:@"username"];
    [dictionay setObject:@"ALFLMLILPLBJFK" forKey:@"password"];
    [dictionay setObject:[MgnfDeviceInfo getDeviceId] forKey:@"deviceId"];
    
    NSString* bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if ([bundleID isEqualToString:@"com.tencent.qqmusic"]) {
        bundleVersion = [self getMusicVersion];
    }
    
    
    [dictionay setObject:bundleVersion forKey:@"versionName"];
    NSLog(@"===============================ipa version:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    NSArray *keys = [dictionay allKeys];
    for(int i=0;i<[keys count];i++){
        NSString *key = [keys objectAtIndex:i];
        NSString* value = [dictionay objectForKey:key];
        t = (int)time(NULL);
        NSString *boundary = [NSString stringWithFormat:@"--------%d3432ksfjkdkkdfjahhdj", t];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: text/plain\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"content-transfer-encoding: quoted-printable\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //上传文件
    NSData* fileData=[NSData dataWithContentsOfFile:zippedPath];
    t = (int)time(NULL);
    boundary = [NSString stringWithFormat:@"--------%d3432ksfjkdkkdfjahhdj", t];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:
     [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.zip\"\r\n", fileName,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:fileData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = body;
    [request setTimeoutInterval:TIMEOUT];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    DLog(@"====================================begin to upload file==================================================");
    NSData* retData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    DLog(@"====================================upload file finished==================================================");
    //删除压缩文件
    [fileManager removeItemAtPath:zippedPath error:nil];
    //网络连接错误
    if (error!=nil) {;
        DLog(@"error code:%d",(int)error.code);
        return (int)error.code;
    }
    //返回状态码
    if(response.statusCode!=200)
    {
        DLog(@"status code:%d",(int)response.statusCode);
        return (int)response.statusCode;
    }
    NSDictionary* retDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    DLog(@"%@",retDic);
    //解析返回字符串
    if ([retDic[@"result"] isEqualToString:@"ok"]) {
        return 0;
    }
    NSString* retDatas = retDic[@"datas"];
//    DLog(@"ret datas:%@",retData);
    NSArray* errorStr = [NSArray arrayWithObjects:
                         @"notSystemUser",
                         @"not allow current device to upload file",
                         @"file name format error, not like timeStr=processName@dumpfileType@alarmInfor",
                         @"ignore current version upload file",
                         @"file name time str format error",
                         @"no file uploaded",
                         @"dump file too small to ignore not store current file",
                         @"occureException",nil];
    int index = (int)[errorStr indexOfObject:retDatas];
    return (index+1);
}




- (int)uploadPerfData:(NSData*)data name:(NSString*)name type:(int)type desc:(NSString*)desc relativeKey:(int)relativeKey
{
    NSString *path = NSTemporaryDirectory();
    path = [path stringByAppendingString:name];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createFileAtPath:path contents:data attributes:nil];
    int ret = [self uploadAnalyseFileWithPath:path type:type Desc:desc RelativeKey:relativeKey];
    [fileManager removeItemAtPath:path error:nil];
    return ret;
}

-(NSString*) getMusicVersion
{
    NSString* stringCurrentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray* arrayVersion = [stringCurrentVersion componentsSeparatedByString:@"."];
    
    NSString* strSvnVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    
    NSUInteger iCount = [arrayVersion count];
    NSInteger iMajorVersion = (iCount >= 1) ? [[arrayVersion objectAtIndex:0] integerValue] : 0;
    NSInteger iMinorVersion = (iCount >= 2) ? [[arrayVersion objectAtIndex:1] integerValue] : 0;
    NSInteger iFixVersion =   (iCount >= 3) ? [[arrayVersion objectAtIndex:2] integerValue] : 0;
    NSInteger iSvnVersion = [strSvnVersion integerValue];
    Class Version = NSClassFromString(@"Version");
    int innerVersion = [Version performSelector:@selector(innerBuildNumber)];
    NSString*  strQQMusicFormalVersion = [NSString stringWithFormat:@"%zd.%zd.%zd.%zd.%zd", iMajorVersion, iMinorVersion, iFixVersion, innerVersion, iSvnVersion];
    return strQQMusicFormalVersion;
    
}




@end
