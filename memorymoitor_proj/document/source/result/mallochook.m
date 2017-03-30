//
//  mallochook.c
//  memorydemo
//
//  Created by michaelbi on 16/10/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#include "mallochook.h"
#import "fishhook.h"
#import "FBAllocationTracker/FBAllocationTrackerManager.h"
#import  <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
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




static NSMutableArray * freearray;
NSLock *writeLock;
OSSpinLock spinlock = OS_SPINLOCK_INIT;
OSSpinLock malloclock=OS_SPINLOCK_INIT;


void printmallocinf(struct mallocinfo_t tmp) 
{
    printf("address : %p, size : %u,  name : %s .\n", tmp.address, tmp.size, tmp.name);
    //fprintf(logfile, "address : %p, size : %u,  name : %s .\n", tmp.address, tmp.size, tmp.name);
}

static void* (*orig_malloc) (size_t size, const void *caller);
static void (*orig_free) (void *ptr, const void *caller);
static bool didHookOriginalMethods = false;


void save_original_symbols() 
{
    orig_malloc = dlsym(RTLD_DEFAULT, "malloc");
    orig_free = dlsym(RTLD_DEFAULT, "free");
}

void *my_malloc (size_t size, const void *caller) 
{

    OSSpinLockLock(&malloclock);

    void * result = orig_malloc(size,caller);

    if(didHookOriginalMethods) 
    {
        printf("Calling real malloc result is %p size is %zu\n", result, size);
        printf("%s", %object_getClassName((__bridge id)(result)));
        recordMallocStack((vm_address_t)result, (uint32_t)size,"malloc",2);
    }

    OSSpinLockUnlock(&malloclock);

    return result;
}


void my_free(void *ptr, const void *caller)
{
    OSSpinLockLock(&malloclock);

    orig_free(ptr,caller);

    OSSpinLockUnlock(&malloclock);
}


void turnOnMallocTracker(void)
{

    if(didHookOriginalMethods)
    {
        return;
    }

    freearray = [[NSMutableArray alloc]init];
    writeLock = [[NSLock alloc] init];
    didHookOriginalMethods =true;
    save_original_symbols();

    rebind_symbols((struct rebinding[2]){{"malloc",my_malloc},{"free",my_free}}, 2);
}

void turnOffMallocTracker(void)
{

    if(!didHookOriginalMethods)
    {
        return;
    }

    didHookOriginalMethods =false;

    allimagecount=0;
}
