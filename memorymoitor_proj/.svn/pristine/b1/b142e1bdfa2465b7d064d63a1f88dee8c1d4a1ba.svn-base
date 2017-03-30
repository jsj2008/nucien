//
//  AppDelegate.m
//  stack pointer
//
//  Created by michaelbi on 16/11/28.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 * 关于栈帧的布局可以参考：
 * https://en.wikipedia.org/wiki/Call_stack
 * http://www.cs.cornell.edu/courses/cs412/2008sp/lectures/lec20.pdf
 * http://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/
 */
typedef struct JDYStackFrame {
    const struct JDYStackFrame* const previous;
    const uintptr_t returnAddress;
} JDYStackFrame;

//

bool jdy_fillThreadStateIntoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
    mach_msg_type_number_t state_count = x86_THREAD_STATE64_COUNT;
    kern_return_t kr = thread_get_state(thread, x86_THREAD_STATE64, (thread_state_t)&machineContext->__ss, &state_count);
    return (kr == KERN_SUCCESS);
}


int jdy_backtraceThread(thread_t thread, uintptr_t *backtraceBuffer, int limit) {
    if (limit <= 0) return 0;
    
    _STRUCT_MCONTEXT mcontext;
    if (!jdy_fillThreadStateIntoMachineContext(thread, &mcontext)) {
        return 0;
    }
    
    int i = 0;
    uintptr_t pc = jdy_programCounterOfMachineContext(&mcontext);
    backtraceBuffer[i++] = pc;
    if (i == limit) return i;
    
    uintptr_t lr = jdy_linkRegisterOfMachineContext(&mcontext);
    if (lr != 0) {
        /* 由于lr保存的也是返回地址，所以在lr有效时，应该会产生重复的地址项 */
        backtraceBuffer[i++] = lr;
        if (i == limit) return i;
    }
    
    JDYStackFrame frame = {0};
    uintptr_t fp = jdy_framePointerOfMachineContext(&mcontext);
    if (fp == 0 || jdy_copyMemory((void *)fp, &frame, sizeof(frame)) != KERN_SUCCESS) {
        return i;
    }
    
    while (i < limit) {
        backtraceBuffer[i++] = frame.returnAddress;
        if (frame.returnAddress == 0
            || frame.previous == NULL
            || jdy_copyMemory((void *)frame.previous, &frame, sizeof(frame)) != KERN_SUCCESS) {
            break;
        }
    }
    
    return i;
@end
