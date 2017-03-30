//
//  imageStackinfo.h
//  memorydemo
//
//  Created by michaelbi on 16/11/2.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import  <dlfcn.h>
#include <stdio.h>
#include <mach/mach.h>
#include <mach/machine/thread_status.h>
#include <pthread.h>
#include <malloc/malloc.h>
#include <libkern/OSSpinLockDeprecated.h>
#import <mach/mach_init.h>
#import <sys/mman.h>
#include <execinfo.h>
#include <string.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

#ifdef __LP64__
#define MY_THREAD_STATE_COUTE ARM_THREAD_STATE64_COUNT
#define MY_THREAD_STATE ARM_THREAD_STATE64
#define MY_EXCEPTION_STATE_COUNT ARM_EXCEPTION_STATE64_COUNT
#define MY_EXCEPITON_STATE ARM_EXCEPTION_STATE64
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT_64
#else
#define MY_THREAD_STATE_COUTE ARM_THREAD_STATE_COUNT
#define MY_THREAD_STATE ARM_THREAD_STATE
#define MY_EXCEPITON_STATE ARM_EXCEPTION_STATE
#define MY_EXCEPTION_STATE_COUNT ARM_EXCEPTION_STATE_COUNT
#define MY_SEGMENT_CMD_TYPE LC_SEGMENT
#endif

#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
#endif /* imageStackinfo_h */

#ifdef abc
struct StackImage{
    const char* name;
    long loadAddr;
    long beginAddr;
    long endAddr;
};
#endif

StackImage allstackimage[1024*100];
int allimagecount = 0;

void getImageByAddr(long addr,StackImage *image);

void initallstackimage();
