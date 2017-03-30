//
//  FileCache.m
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/26.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import "MgnfFileCache.h"
#import "MgnfLogger.h"
#import <mach-o/dyld.h>

@implementation MgnfFileCache

- (id)initWithType:(int)type
{
    if (self = [super init]){
        m_itemCaches = [NSMutableArray arrayWithCapacity:0];
        m_type = type;

    }
    return self;
}
- (void)addItem:(NSString*)item
{
    [m_itemCaches addObject:item];
    

}

-(NSString*)writeToDisk
{
    NSString* path = @"";
    if ([m_itemCaches count]>0) {
        DLog(@"========================begin to write, the total itmes count:%d========================",(int)[m_itemCaches count]);
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [formatter setDateFormat:@"YYMMdd_HHmmss_SSS"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
//        path = [NSString stringWithFormat:@"%@iomonitor_%@.io",NSTemporaryDirectory(),dateString];
        path = [NSString stringWithFormat:@"%@iomonitor_%@.io",NSTemporaryDirectory(),dateString];
        FILE* fp;
        fp = fopen([path UTF8String], "a+");
//        NSString *header = [NSString stringWithFormat:@"fd,openTime(s),filePath,process,threadID,threadName,readCount,readBytes,readConsume(ms),writeCount,writeBytes,writeConsume(ms),callStack\n"];
        NSString *header = [NSString stringWithFormat:@"filePath,process,thread,readCount,readBytes,readConsume(ms),writeCount,writeBytes,writeConsume(ms),callStack\n"];
        fprintf(fp, "%s",[header UTF8String]);
         for (NSString* item in m_itemCaches) {
             fprintf(fp, "%s",[item UTF8String]);
         }
        fflush(fp);
        fclose(fp);
        [m_itemCaches removeAllObjects];
    }
    return path;
}

-(NSInteger)count
{
    return [m_itemCaches count];
}



-(void)removeAllObject
{
    if ([m_itemCaches count]>0) {
        [m_itemCaches removeAllObjects];
    }
}



@end
