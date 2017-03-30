//
//  mallochook.c
//  memorydemo
//
//  Created by michaelbi on 16/10/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#include "mallochook.h"
#import <Foundation/Foundation.h>



static NSMutableArray * freearray;
NSLock *writeLock;
OSSpinLock spinlock = OS_SPINLOCK_INIT;
OSSpinLock malloclock=OS_SPINLOCK_INIT;
static void* (*orig_malloc) (size_t size, const void *caller);
static void (*orig_free) (void *ptr, const void *caller);
static bool didHookOriginalMethods = false;
void recordMallocStack(vm_address_t address, uint32_t size, const char*name, size_t stack_num_to_skip);
void recordFreeStack(vm_address_t address, const char*name, size_t stack_num_to_skip);


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
        //printf("%s", object_getClassName((__bridge id)(result)));
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
    initallstackimage();
    ptrs_hashmap = hashmap_new();
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
    hashmap_free(ptrs_hashmap);
    didHookOriginalMethods =false;

    allimagecount=0;
}


#define max_stack_depth 128
OSSpinLock spinlock;
void recordMallocStack(vm_address_t address, uint32_t size, const char*name, size_t stack_num_to_skip)
{
    if(1)
    {
        base_ptr_t base_ptr = *(base_ptr_t*)malloc_zone_malloc(malloc_default_zone(), sizeof(base_ptr_t));
        
        vm_address_t *stack[max_stack_depth];
        base_ptr.depth = backtrace(stack, 128);
        if(base_ptr.depth > 0)
        {
            base_ptr.stack = (vm_address_t**)malloc_zone_malloc(malloc_default_zone(), base_ptr.depth*sizeof(vm_address_t*));
            memcpy(base_ptr.stack, stack, base_ptr.depth*sizeof(vm_address_t*));
            memcpy(base_ptr.name, name, strlen(name));
            base_ptr.size = size;
            base_ptr.address = address;
            
            OSSpinLockLock(&spinlock);
            
            if(ptrs_hashmap)
            {
                hashmap_put(ptrs_hashmap, address, &base_ptr);
            }
            
            OSSpinLockUnlock(&spinlock);
        }
    }
}


void recordFreeStack(vm_address_t address, const char*name, size_t stack_num_to_skip)
{
    if(1)
    {
        OSSpinLockLock(&spinlock);
        
        if(ptrs_hashmap)
        {
            vm_address_t tmp;
            hashmap_get(ptrs_hashmap, address, &tmp);
            malloc_zone_free(malloc_default_zone, tmp);
            hashmap_remove(ptrs_hashmap, address);
        }
        
        OSSpinLockUnlock(&spinlock);
    }
}
