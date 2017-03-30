//
//  mallochook.h
//  memorydemo
//
//  Created by michaelbi on 16/10/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

//#ifndef INCLUDE_MALLOCHOOK
//#define INCLUDE_MALLOCHOOK


#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
#endif

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


#import "BasicFunction.h"


void turnOnMallocTracker(void);
void turnOffMallocTracker(void);

void my_free(void *ptr, const void *caller);
void *my_malloc (size_t size, const void *caller);




typedef struct{
    const char* name;
    long loadAddr;
    long beginAddr;
    long endAddr;
}StackImage;

//typedef struct
//{
//    uint32_t size;
//    uint32_t depth;
//    vm_address_t **stack;
//    char name[16];
//    vm_address_t address;
//}base_ptr_t;

long getMap();
void getImageByAddr(long addr,StackImage *image);

extern void *ptrs_hashmap;
//#endif
