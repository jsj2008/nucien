//
//  IOHook.m
//
//  Created by jackyjiao on 7/9/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//


#import "MgnfIOHook.h"
#import <dlfcn.h>
#import "fishhook.h"
#import "MgnfIODataCenter.h"
#import "MgnfLogger.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import "ImageInfo.h"
#import <Foundation/Foundation.h>
#import "NSThread+Num.h"


static MgnfIODataCenter* s_ioDataCenter = nil;
static BOOL s_bStart = NO;
static BOOL s_bDeug = NO;

static int (*orig_open)(const char *path, int oflag,...);
static ssize_t (*orig_read)(int fd, void *buf, size_t count);
static ssize_t (*orig_pread)(int fd, void *buf, size_t count, off_t offset);
static ssize_t (*orig_write)(int fd, const void *buf, size_t count);
static ssize_t (*orig_pwrite)(int fd, const void *buf, size_t count, off_t offset);
static int (*orig_close)(int fd);
static int (*orig_UIApplicationMain)(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);


void save_original_symbols() {
    
    
    orig_open = dlsym(RTLD_DEFAULT, "open");
    orig_read = dlsym(RTLD_DEFAULT, "read");
    orig_pread = dlsym(RTLD_DEFAULT, "pread");
    orig_write = dlsym(RTLD_DEFAULT, "write");
    orig_pwrite = dlsym(RTLD_DEFAULT, "pwrite");
    orig_close  = dlsym(RTLD_DEFAULT, "close");
    orig_UIApplicationMain = dlsym(RTLD_DEFAULT, "UIApplicationMain");


}


NSNumber* getThreadID(NSThread* thread)
{
    long num = [[thread valueForKeyPath:@"private.seqNum"] integerValue];
    return [NSNumber numberWithLong:num];
}

int my_open(const char *path, int oflag,...){
    
    va_list ap = {0};
    mode_t mode = 0;
    
    int retVal;
    
    if ((oflag & O_CREAT) != 0) {
        // mode only applies to O_CREAT
        va_start(ap, oflag);
        mode = va_arg(ap, int);
        va_end(ap);
        
        retVal = orig_open(path, oflag, mode);
//        DLog(@"path:%s",path);
    } else {
        retVal = orig_open(path, oflag, mode);
//        DLog(@"path:%s",path);
    }
//    DLog(@"==================open,threadID:%@,path:%s,%d=================",getThreadID([NSThread currentThread]),path,retVal);
    if (s_bStart==NO) {
        return retVal;
    }
    
    
    if (retVal>0) {
        if (s_ioDataCenter!=nil)
        {
            NSString* tname = [NSThread currentThread].name;
            if ([NSThread isMainThread])
            {
                tname = @"main";
            }
            
            if ([tname length]==0) {
                tname = @"subThread";
            }
            
            if (s_bDeug) {
                [s_ioDataCenter onHookOpenWithFd:[NSNumber numberWithInt:retVal] Path:[NSString stringWithUTF8String:path] ThreadID:getThreadID([NSThread currentThread]) ThreadName:tname Time:[NSNumber numberWithDouble:CFAbsoluteTimeGetCurrent()] CallStack:[NSThread callStackSymbols]];
            }
            else
            {
                [s_ioDataCenter onHookOpenWithFd:[NSNumber numberWithInt:retVal] Path:[NSString stringWithUTF8String:path] ThreadID:getThreadID([NSThread currentThread]) ThreadName:tname Time:[NSNumber numberWithDouble:CFAbsoluteTimeGetCurrent()] CallStack:[NSThread callStackReturnAddresses]];
            }

        }
        
    }
    return retVal;
}

ssize_t my_read(int fd, void *buf, size_t count){
    ssize_t retVal = orig_read(fd,buf,count);
    if (s_bStart==NO) {
        return retVal;
    }
//    DLog(@"==================read,threadID:%@,%d==================",getThreadID([NSThread currentThread]),fd);
//    DLog(@"hook:read");
    if (retVal>0) {
        if (s_ioDataCenter!=nil) {
            [s_ioDataCenter onHookReadWithFd:[NSNumber numberWithInt:fd] Bytes:[NSNumber numberWithLong:count]];
        }
    }
    return retVal;
}

ssize_t my_pread(int fd, void *buf, size_t count, off_t offset){

    ssize_t retVal = orig_pread(fd,buf,count,offset);
    if (s_bStart==NO) {
        return retVal;
    }

//    DLog(@"hook:pread");
    if (retVal>0) {
        if (s_ioDataCenter!=nil) {
            [s_ioDataCenter onHookReadWithFd:[NSNumber numberWithInt:fd] Bytes:[NSNumber numberWithLong:count]];
        }
    }
    return retVal;
}

ssize_t my_write(int fd, const void *buf, size_t count) {

    ssize_t retVal = orig_write(fd,buf,count);
    if (s_bStart==NO) {
        return retVal;
    }
//    DLog(@"==================write,threadID:%@,%d==================",getThreadID([NSThread currentThread]),fd);
//    DLog(@"hook:write");
    if (retVal>0) {
        if (s_ioDataCenter!=nil) {
            [s_ioDataCenter onHookWriteWithFd:[NSNumber numberWithInt:fd] Bytes:[NSNumber numberWithLong:count]];
        }
        
    }
    return retVal;
}

ssize_t my_pwrite(int fd, const void *buf, size_t count, off_t offset) {

    ssize_t retVal = orig_pwrite(fd,buf,count,offset);
    if (s_bStart==NO) {
        return retVal;
    }
//    DLog(@"hook:pwrite");
    if (retVal>0) {
        if (s_ioDataCenter!=nil) {
            [s_ioDataCenter onHookWriteWithFd:[NSNumber numberWithInt:fd] Bytes:[NSNumber numberWithLong:count]];
        }
        
    }
    return retVal;
}




int my_close(int fd){
    

    
    int retVal = orig_close(fd);
//    DLog(@"close file,thread:%@,fd:%d",[[NSThread currentThread] sequenceNumber],fd);
    if (s_bStart==NO) {
        return retVal;
    }
//    DLog(@"hook:closed,%d",fd);
//    DLog(@"====================================================================================================");
    if (retVal==0) {
        if (s_ioDataCenter!=nil) {
            [s_ioDataCenter onHookCloseWithFd:[NSNumber numberWithInt:fd]];
        }
    }
    return retVal;
}



void (*orig_applicationDidEnterBackground)(id, SEL, UIApplication *);
void new_applicationDidEnterBackground(id self, SEL _cmd, UIApplication * application) {
    orig_applicationDidEnterBackground(self,_cmd,application);
    if (s_ioDataCenter) {
        [s_ioDataCenter saveToDiskAndUploadInMainThread];
    }
}

double cur_time;

BOOL (*orig_applicationdidFinishLaunchingWithOptions)(id, SEL, UIApplication *,NSDictionary *);
BOOL new_applicationdidFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication * application,NSDictionary* launchOptions) {
    DLog(@"====================================================================================================");
    DLog(@"**************enter applicationdidFinishLaunchingWithOptions**************");
    startIOHook();
    double startTime= CFAbsoluteTimeGetCurrent();
    BOOL ret = orig_applicationdidFinishLaunchingWithOptions(self,_cmd,application,launchOptions);
    DLog(@"=============applicationdidFinishLaunchingWithOptions,cost %f",CFAbsoluteTimeGetCurrent()-startTime);
    stopIOHook();
    startIOHook();
    cur_time = CFAbsoluteTimeGetCurrent();
    return ret;
}


BOOL (*orig_viewDidAppear)(id,SEL,BOOL);
BOOL new_viewDidAppear(id self, SEL _cmd,BOOL animated)
{
    
    BOOL ret = orig_viewDidAppear(self,_cmd,animated);
    DLog(@"=============viewDidAppear,cost %f",CFAbsoluteTimeGetCurrent()-cur_time);
    stopIOHook();
    return ret;
}





BOOL MSHookFunction(Class class, SEL original, IMP replacement, IMP* store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}


static int my_UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
{
    //QQ是个特例，未完待续....
    if (delegateClassName==nil) {
        delegateClassName = @"QQAddressBookAppDelegate";
    }

    MSHookFunction(objc_getClass([delegateClassName UTF8String]),@selector(applicationDidEnterBackground:),(IMP)new_applicationDidEnterBackground,(IMP*)&orig_applicationDidEnterBackground);
    
//    MSHookFunction(objc_getClass([delegateClassName UTF8String]),@selector(application:didFinishLaunchingWithOptions:),(IMP)new_applicationdidFinishLaunchingWithOptions,(IMP*)&orig_applicationdidFinishLaunchingWithOptions);
//    
//    MSHookFunction(objc_getClass("UIInputWindowController"),@selector(viewDidAppear:),(IMP)new_viewDidAppear,(IMP*)&orig_viewDidAppear);
    return orig_UIApplicationMain(argc, argv, principalClassName,delegateClassName);
}





void setBackupMode(BOOL bBackup)
{
    if (s_ioDataCenter!=nil) {
        [s_ioDataCenter setBackupMode:bBackup];
    }
}

void setDebugMode(BOOL bDebug)
{
    if (s_ioDataCenter!=nil) {
        [s_ioDataCenter setDebugMode:bDebug];
        s_bDeug = bDebug;
    }
}


void init()
{
    if (s_ioDataCenter==nil) {
        s_ioDataCenter = [[MgnfIODataCenter alloc]init];
        save_original_symbols();
        rebind_symbols((struct rebinding[6]){{"open",my_open},{"read",my_read},{"pread", my_pread},{"write", my_write},{"pwrite", my_pwrite},{"close", my_close}}, 6);
        
        rebind_symbols((struct rebinding[1]){{"UIApplicationMain",my_UIApplicationMain}}, 1);
    }
}

void startIOHook()
{
    
    s_bStart = YES;
    DLog(@"startIOHook");
    
}



void stopIOHook()
{
    //移除这些symbol
    if (s_ioDataCenter!=nil) {
        s_bStart = NO;
        [s_ioDataCenter saveToDiskAndUploadInMainThread];
        DLog(@"stopIOHook");

    }
}





static __attribute__((constructor)) void onLoad(){
    init();
#if defined (DYLIB)
    setBackupMode(YES);
    setDebugMode(NO);
    DLog("dylib is loaded");
    startIOHook();
#endif
    
}

static __attribute__((destructor)) void onUnload(){
#if defined (DYLIB)
    DLog("dylib is unloaded");
    stopIOHook();
#endif
}
