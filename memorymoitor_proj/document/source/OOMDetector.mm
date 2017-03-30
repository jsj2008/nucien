//
//  OOMDetector.mm
//  QQLeak
//
//  Created by rosen on 16/11/1.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "OOMDetector.h"
#include "CStacksHashmap.h"
#include "CMallocStackLogging.h"
#import <libkern/OSAtomic.h>
#include <sys/mman.h>
#include "CMachOHelper.h"
#import "stdio.h"
#include <mach/mach_init.h>
#import "QQLeakPredefines.h"

#ifdef __Enable_OOMCathcer__

static OOMDetector *catcher;
extern malloc_zone_t *memory_zone;
static NSString *stack_path;
static FILE *fp;
static char *mmap_ptr;
static size_t mmap_size = 512*1024;
static size_t current_len = 0;
static size_t threshHold ;
static BOOL enableTrack;
static NSString *currentDir;
extern malloc_logger_t* __syscall_logger;
extern size_t max_stack_depth;
void mmapSprintf(const char *format, ...);

#define stack_logging_type_free             0
#define stack_logging_type_generic          1
#define stack_logging_type_alloc            2
#define stack_logging_type_dealloc          4
#define	stack_logging_flag_zone             8
#define	stack_logging_flag_calloc           16
#define stack_logging_flag_object           32
#define stack_logging_flag_cleared          64
#define stack_logging_flag_handle           128
#define stack_logging_flag_set_handle_size	256

#define MALLOC_LOG_TYPE_ALLOCATE	stack_logging_type_alloc
#define MALLOC_LOG_TYPE_DEALLOCATE	stack_logging_type_dealloc
#define MALLOC_LOG_TYPE_HAS_ZONE	stack_logging_flag_zone
#define MALLOC_LOG_TYPE_CLEARED		stack_logging_flag_cleared

static void oom_malloc_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    if(arg1 != (uintptr_t)default_zone){
        return ;
    }
    if (type & stack_logging_flag_zone) {
        type &= ~stack_logging_flag_zone;
    }
    if (type == (stack_logging_type_dealloc|stack_logging_type_alloc)) {
        if (arg2 == result) {
            removeMallocStack((vm_address_t)arg2);
            recordMallocStack(result, (uint32_t)arg3,NULL,4,OOMDetectorMode);
            return;
        }
        if (!arg2) {
            recordMallocStack(result, (uint32_t)arg3,NULL,4,OOMDetectorMode);
            return;
        } else {
            removeMallocStack((vm_address_t)arg2);
            recordMallocStack(result, (uint32_t)arg3,NULL,4,OOMDetectorMode);
            return;
        }
    }
    if (type == stack_logging_type_dealloc) {
        if (!arg2) return;
        removeMallocStack((vm_address_t)arg2);
    }
    else if((type & stack_logging_type_alloc) != 0){
        recordMallocStack(result, (uint32_t)arg2,NULL,4,OOMDetectorMode);
    }
}

void flush_malloc_stack()
{
    current_len = 0;
 //   CFAbsoluteTime start_time = CFAbsoluteTimeGetCurrent();
    NSDateFormatter* df = [[NSDateFormatter new] autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    mmapSprintf("%s total_malloc_num:%ld stack_num:%ld\n",[dateStr UTF8String],ptrs_hashmap->getRecordNum(),stacks_hashmap->getRecordNum());
    OSSpinLockLock(&hashmap_spinlock);
    int exceedNum = 0;
    for(size_t i = 0; i < stacks_hashmap->getEntryNum(); i++){
        base_entry_t *entry = stacks_hashmap->getHashmapEntry() + i;
        merge_stack_t *current = (merge_stack_t *)entry->root;
        while(current != NULL){
            if(current->extra.size > threshHold){
                exceedNum++;
                mmapSprintf("Malloc_size:%lfmb num:%u stack:\n",(double)(current->extra.size)/(1024*1024), current->count);
                for(size_t j = 0; j < current ->depth; j++){
                    vm_address_t addr = (vm_address_t)current->stack[j];
                    segImageInfo segImage;
                    if(getImageByAddr(addr, &segImage)){
                        mmapSprintf("\"%lu %s 0x%lx 0x%lx\" ",j,(segImage.name != NULL) ? segImage.name : "unknown",segImage.loadAddr,(long)addr);
                    }
                }
                mmapSprintf("\n");
            }
            current = current->next;
        }
    }
    if(exceedNum == 0){
        current_len = 0;
        memset(mmap_ptr, '\0', mmap_size);
    }
    msync(mmap_ptr, mmap_size, MS_ASYNC);
 //   int ret = msync(mmap_ptr, mmap_size, MS_ASYNC);
    OSSpinLockUnlock(&hashmap_spinlock);
//    if(ret == -1){
//        NSLog(@"msync failed, reason:%d!", errno);
//    }
//    CFAbsoluteTime time_cost = CFAbsoluteTimeGetCurrent() - start_time;
//    NSLog(@"%s cost:%lfms", __FUNCTION__, time_cost*1000);
}

void mmapSprintf(const char *format, ...)
{
    va_list args;
    va_start(args, format);
    if(strlen(format) + current_len < mmap_size){
        current_len += vsprintf(mmap_ptr + current_len, format, args);
    }
    else {
        char *copy = (char *)memory_zone->malloc(memory_zone, mmap_size);
        memcpy(copy, mmap_ptr, mmap_size);
        munmap(mmap_ptr ,mmap_size);
        size_t copy_size = mmap_size;
        mmap_size += 512*1024;
        int ret = ftruncate(fileno(fp), mmap_size);
        if(ret == -1){
            enableTrack = NO;
        }
        else {
            fseek(fp, 0, SEEK_SET);
            mmap_ptr = (char *)mmap(0, mmap_size, PROT_WRITE | PROT_READ, (MAP_FILE|MAP_SHARED), fileno(fp), 0);
            memset(mmap_ptr, '\0', mmap_size);
            if(!mmap_ptr){
                enableTrack = NO;
            }
            else {
                enableTrack = YES;
                memcpy(mmap_ptr, copy, copy_size);
                current_len += vsprintf(mmap_ptr + current_len, format, args);
            }
        }
        memory_zone->free(memory_zone,copy);
    }
    va_end(args);
}

@implementation OOMDetector

+(OOMDetector *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catcher = [OOMDetector new];
    });
    return catcher;
}

-(id)init
{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *LibDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDateFormatter* df = [[NSDateFormatter new] autorelease];
        df.dateFormat = @"yyyyMMdd_HHmmssSSS";
        NSString *dateStr = [df stringFromDate:[NSDate date]];
        currentDir = [[LibDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"OOMDetector/%@",dateStr]] retain];
        if (![fileManager fileExistsAtPath:currentDir]) {
            [fileManager createDirectoryAtPath:currentDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        stack_path = [[currentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"malloc%@.log",dateStr]] retain];
        if (![fileManager fileExistsAtPath:stack_path]) {
            [fileManager createFileAtPath:stack_path contents:nil attributes:nil];
        }
        fp = fopen ( [stack_path fileSystemRepresentation] , "wb+" ) ;
        int ret = ftruncate(fileno(fp), mmap_size);
        if(ret == -1){
            enableTrack = NO;
        }
        else {
            fseek(fp, 0, SEEK_SET);
            mmap_ptr = (char *)mmap(0, mmap_size, PROT_WRITE | PROT_READ, (MAP_FILE|MAP_SHARED), fileno(fp), 0);
            memset(mmap_ptr, '\0', mmap_size);
            if(!mmap_ptr){
                enableTrack = NO;
            }
            else {
                enableTrack = YES;
            }
        }
    }
    return self;
}

-(NSString *)currentLogDir
{
    return currentDir;
}

-(BOOL)startOOMDetector:(NSTimeInterval)flushInterval threshHoldInbytes:(size_t)bytes
{
    if(enableTrack){
        if(memory_zone == nil){
            memory_zone = malloc_create_zone(0, 0);
            malloc_set_zone_name(memory_zone, "OOMDetector");
        }
        default_zone = malloc_default_zone();
        current_mode = OOMDetectorMode;
        ptrs_hashmap_entrys = 150000;
        stacks_hashmap = new CStacksHashmap(ptrs_hashmap_entrys/2);
        ptrs_hashmap = new CPtrsHashmap(ptrs_hashmap_entrys);
        initAllImages();
        malloc_logger = (malloc_logger_t *)oom_malloc_logger;
        threshHold = bytes;
        return YES;
    }
    return NO;
}

-(void)stopOOMDetector
{
    malloc_logger = NULL;
    OSSpinLockLock(&hashmap_spinlock);
    delete stacks_hashmap;
    delete ptrs_hashmap;
    stacks_hashmap = NULL;
    ptrs_hashmap = NULL;
    OSSpinLockUnlock(&hashmap_spinlock);
}

-(void)setMaxStackDepth:(size_t)depth
{
    if(depth > 0) max_stack_depth = depth;
}

-(void)flush_malloc_stack
{
    flush_malloc_stack();
}

-(void)dealloc
{
    munmap(mmap_ptr ,mmap_size);
    [super dealloc];
}

@end

#endif

