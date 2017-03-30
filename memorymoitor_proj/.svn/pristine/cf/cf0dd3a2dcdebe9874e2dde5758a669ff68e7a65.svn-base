//
//  ViewController.m
//  stacktarck
//
//  Created by michaelbi on 16/12/30.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "ViewController.h"
#import <mach/mach_types.h>
#import "AppDelegate.h"
#import <mach/mach_types.h>
#import <pthread.h>
#include <sys/types.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include <sys/_types/_ucontext64.h>
#define	mach_task_self() mach_task_self_
#define	current_task()	mach_task_self()
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include <dlfcn.h>
#include <stdio.h>
#include <mach/arm/thread_state.h>
extern mach_port_t	mach_task_self_;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bianliAllTheThread
{
    thread_act_array_t threads = 0;
    mach_msg_type_number_t thread_count = 0;
    task_t currTask = mach_task_self();
    thread_t currThread = mach_thread_self();
    task_threads(currTask, &threads, &thread_count);
    
    for (mach_msg_type_number_t i = 0; i < thread_count; ++i)
    {
        rqd_backtrace_t bt;
        memset(&bt, 0, sizeof(bt));
        mach_msg_type_number_t nc;
        kern_return_t k1 = thread_get_state(threads[i], ARM_THREAD_STATE64, (thread_state_t)&bt.mc.__ss, &(nc=ARM_THREAD_STATE64_COUNT));
        kern_return_t k2 = thread_get_state(threads[i], ARM_NEON_STATE64, (thread_state_t)&bt.mc.__ns, &(nc=ARM_NEON_STATE64_COUNT));
        kern_return_t k3 = thread_get_state(threads[i], ARM_EXCEPTION_STATE64, (thread_state_t)&bt.mc.__es, &(nc=ARM_EXCEPTION_STATE64_COUNT));
        _STRUCT_ARM_THREAD_STATE64 tmp = bt.mc.__ss;
        
    }
}

@end
