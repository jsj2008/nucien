//
//  BasicFunction.h
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/3/13.
//  Copyright © 2017年 王哲锴. All rights reserved.
//
#ifdef __OBJC__
#import <Foundation/Foundation.h>

#ifndef BasicFunction_h
#define BasicFunction_h


#endif /* BasicFunction_h */

#include "hashmap.h"
#include "MachOHelpler.h"
#include <mach/mach.h>
#include <stdlib.h>
#include <mach/machine/thread_status.h>
#include <pthread.h>
#include <malloc/malloc.h>
#include <libkern/OSSpinLockDeprecated.h>
#include <execinfo.h>
#include <string.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <mach/mach_init.h>
#import <sys/mman.h>
#import <dlfcn.h>
#import "fishhook.h"
#import "GlobalMemory.h"
#import "StackMemory.h"
#import "HeapMemory.h"
#import "malloc_logger.h"
#import "mallochook.h"
#import "AllocHookTool.h"
#import "NSObject+allochook.h"




#define max_stack_depth 128


typedef struct
{
    uint32_t size;
    uint32_t depth;
    vm_address_t **stack;
    vm_address_t md5;
    char name[16];
    vm_address_t address;
}base_ptr_t;

typedef struct{
    int frames;
    void* stack[128];
}CallBackStack;

@interface BasicFunction : NSObject
-(NSMutableArray *)getStackInfo:(CallBackStack)callStack;
@end
#endif

extern malloc_zone_t *memory_zone;
extern void *ptrs_hashmap;
extern void *pmap;



void hook_init();
void recordStack(vm_address_t address, uint32_t size, const char*name);
void removeStack(vm_address_t address,const char*name);
char *longToString(long x);
long stringToLong(char *x);
void suspendThread();
void stopMonitor();


