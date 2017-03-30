#line 1 "/work/xcodeProject/hookApp/hookApp/hookApp.xm"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <dlfcn.h>
#import "substrate.h"

#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import <dlfcn.h>

#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
typedef struct nlist_64 nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT_64
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
typedef struct nlist nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT
#endif


int (*orig_main)(int argc, char* argv[]);
int new_main(int argc,char* argv[])
{
    NSLog(@"new_maingfaghgsdhfgehdfgdhdf");
    return orig_main(argc,argv);
}


static __attribute__((constructor)) void _logosLocalCtor_1c383cd3()
{
    void* p_fun = dlsym(RTLD_DEFAULT, "main");
    NSLog(@"dlsym main:%p",p_fun);
    MSHookFunction((void*)p_fun,(void*)&new_main,(void**)&orig_main);





















}
