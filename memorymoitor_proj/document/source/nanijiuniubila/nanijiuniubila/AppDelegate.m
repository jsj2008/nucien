//
//  AppDelegate.m
//  nanijiuniubila
//
//  Created by michaelbi on 17/1/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <malloc/malloc.h>
#include <sys/mman.h>
malloc_zone_t * default_zone;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    mainfunc();
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


//
//  main.m
//  niubila2
//
//  Created by michaelbi on 17/1/4.
//  Copyright © 2017年 tencent. All rights reserved.
//


//#define MALLOC_LOG_TYPE_ALLOCATE    2
//#define MALLOC_LOG_TYPE_DEALLOCATE  4
//#define MALLOC_LOG_TYPE_HAS_ZONE    8
//#define MALLOC_LOG_TYPE_CLEARED     64
//
//#define MALLOC_OP_MALLOC    (MALLOC_LOG_TYPE_ALLOCATE|MALLOC_LOG_TYPE_HAS_ZONE)
//#define MALLOC_OP_CALLOC    (MALLOC_OP_MALLOC|MALLOC_LOG_TYPE_CLEARED)
//#define MALLOC_OP_REALLOC   (MALLOC_OP_MALLOC|MALLOC_LOG_TYPE_DEALLOCATE)
//#define MALLOC_OP_FREE      (MALLOC_LOG_TYPE_DEALLOCATE|MALLOC_LOG_TYPE_HAS_ZONE)
//
//typedef void (malloc_logger_t)(unsigned, unsigned, unsigned, unsigned, unsigned, unsigned);
//
//// decleared in the Libc malloc implementation
//extern malloc_logger_t *malloc_logger;
//
//void
//print_malloc_record(unsigned type, unsigned arg1, unsigned arg2, unsigned arg3,
//                    unsigned result, unsigned num_hot_franes_to_skip)
//{
//    switch(type) {
//        case MALLOC_OP_MALLOC: //malloc() or valloc()
//        case MALLOC_OP_CALLOC:
//            malloc_printf("%s    : zone=%p, size=%u, pointer=%p\n", (type == MALLOC_OP_MALLOC) ? "malloc" : "calloc", arg1, arg2, result);
//            break;
//        case MALLOC_OP_REALLOC:
//            malloc_printf("realloc   : zone=%p, size=%u, old pointer=%p, "
//                          "new pointer=%p\n", arg1, arg3, arg2, result);
//            break;
//        case MALLOC_OP_FREE:
//            malloc_printf("free      : zone=%p, pointer=%p\n", arg1, arg2);
//            break;
//    }
//}



#define stack_logging_type_free	0
#define stack_logging_type_generic	1
#define stack_logging_type_alloc	2
#define stack_logging_type_dealloc	4
#define	stack_logging_flag_zone		8
#define	stack_logging_flag_calloc	16
#define stack_logging_flag_object 	32
#define stack_logging_flag_cleared	64
#define stack_logging_flag_handle	128
#define stack_logging_flag_set_handle_size	256

#define MALLOC_LOG_TYPE_ALLOCATE	stack_logging_type_alloc
#define MALLOC_LOG_TYPE_DEALLOCATE	stack_logging_type_dealloc
#define MALLOC_LOG_TYPE_HAS_ZONE	stack_logging_flag_zone
#define MALLOC_LOG_TYPE_CLEARED		stack_logging_flag_cleared

typedef void (malloc_logger_t)(unsigned type, unsigned arg1, unsigned arg2, unsigned arg3, unsigned result, unsigned num_hot_frames_to_skip);
extern malloc_logger_t *malloc_logger;


void
do_some_allocations(void)
{
    uintptr_t m, m_new, c, v, m_z;
    malloc_zone_t *zone;
    
    m = malloc(1<<10);
    malloc_printf("m: 0x%lx\n",m);
    m_new = realloc(m, 1<<13);
    v = valloc(1<<10);
    c = calloc(1<<2, 1<<10);
    
    free(m_new);
    free(c);
    free(v);
    
    zone = malloc_create_zone(1<<14, 0);
    m_z = malloc_zone_malloc(zone, 1<<12);
    malloc_zone_free(zone, m_z);
    malloc_destroy_zone(zone);
}


size_t current_len = 0;
static size_t mmap_size = 512*1024;
static char *mmap_ptr;
malloc_zone_t *memory_zone;
static size_t threshHold ;
static BOOL enableTrack;
static FILE *fp;
NSString *filePath;

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





static void _OFMallocLogger(unsigned type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip)
{
    
    if(arg1 != (uintptr_t)default_zone){
        return ;
    }
    if (type & stack_logging_flag_zone) {
        type &= ~stack_logging_flag_zone;
    }

    //malloc_printf("%d\n",type);
    if (type == (stack_logging_type_dealloc|stack_logging_type_alloc)) {
        //realloc
        NSString *ctx = @"";
        ctx = [ctx stringByAppendingFormat:@"[realloc zone=0x%lx oldPtr=0x%lx size=%lu ptr=0x%lx]\n", arg1, arg2, arg3, result];
        [ctx writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        malloc_printf("[realloc zone=0x%lx oldPtr=0x%lx size=%d ptr=0x%lx]\n", arg1, arg2, arg3, result);
    }
    if (type == stack_logging_type_dealloc) {
        NSString *ctx = @"";
        ctx = [ctx stringByAppendingFormat:@"[free zone=0x%lx ptr=0x%lx]\n", arg1, arg2];
        [ctx writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        malloc_printf("[free zone=0x%lx ptr=0x%lx]\n", arg1, arg2);
    }
    else if((type & stack_logging_type_alloc) != 0){
        //malloc
        NSString *ctx = @"";
        ctx = [ctx stringByAppendingFormat:@"[malloc zone=0x%lx size=%lu ptr=0x%lx]\n", arg1, arg2, result];
        [ctx writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        malloc_printf("[malloc zone=0x%lx size=%d ptr=0x%lx]\n", arg1, arg2, result);
    }
    

//    switch (type) {
//        case stack_logging_type_alloc | stack_logging_flag_zone:
//            malloc_printf("[malloc zone=0x%x size=%d ptr=0x%x]\n", arg1, arg2, result);
//            break;
//        case stack_logging_type_alloc | stack_logging_flag_zone | stack_logging_flag_cleared:
//            malloc_printf("[calloc zone=0x%x size=%d ptr=0x%x]\n", arg1, arg2, result);
//            break;
//        case stack_logging_type_alloc | stack_logging_type_dealloc | stack_logging_flag_zone:
//            malloc_printf("[realloc zone=0x%x oldPtr=0x%x size=%d ptr=0x%x]\n", arg1, arg2, arg3, result);
//            break;
//        case stack_logging_type_dealloc | stack_logging_flag_zone:
//            malloc_printf("[free zone=0x%x ptr=0x%x]\n", arg1, arg2);
//            break;
//        default:
//            malloc_printf("[???? type=%d arg1=0x%x arg2=0x%x arg3=0x%x result=0x%x\n", type, arg1, arg2, arg3, result);
//            break;
//    }
}




int
mainfunc(void)
{
    static NSString *stack_path;

    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [path1 objectAtIndex:0];
    filePath = [path stringByAppendingString:@"/stackinfo.txt"];
    NSString *ctx = @"";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    char * what = [filePath UTF8String];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *LibDirectory = [paths objectAtIndex:0];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDateFormatter* df = [NSDateFormatter new];
//    df.dateFormat = @"yyyyMMdd_HHmmssSSS";
//    NSString *dateStr = [df stringFromDate:[NSDate date]];
//    currentDir = [[LibDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"OOMDetector/%@",dateStr]]];
//    if (![fileManager fileExistsAtPath:currentDir]) {
//        [fileManager createDirectoryAtPath:currentDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    stack_path = [[currentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"malloc%@.log",dateStr]] retain];
//    if (![fileManager fileExistsAtPath:stack_path]) {
//        [fileManager createFileAtPath:stack_path contents:nil attributes:nil];
//    }
//    fp = fopen ( [stack_path fileSystemRepresentation] , "wb+" ) ;
    fp = fopen(what,"wb+");


    
    
    
    default_zone = malloc_default_zone();
    memory_zone = malloc_create_zone(0, 0);
    malloc_set_zone_name(memory_zone, "OOMDetector");
    malloc_logger = _OFMallocLogger;

    do_some_allocations();
    
    return 0;
}

@end
