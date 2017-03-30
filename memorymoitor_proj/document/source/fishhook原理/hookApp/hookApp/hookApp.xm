//#import "NSThread+Num.h"
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
    NSLog(@"new_main");
    return orig_main(argc,argv);
}

%ctor
{
    void* p_fun = dlsym(RTLD_DEFAULT, "main");
    NSLog(@"dlsym main:%p",p_fun);
    if(p_fun)
    {
        MSHookFunction((void*)p_fun,(void*)&new_main,(void**)&orig_main);
    }
    else
    {
        uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
        mach_header_t* header = (mach_header_t*)_dyld_get_image_header(0);
        uintptr_t cur = (uintptr_t)header + sizeof(mach_header_t);
        segment_command_t* cur_seg_cmd;
        for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
        {
            cur_seg_cmd = (segment_command_t*)cur;
            if (cur_seg_cmd->cmd==LC_MAIN) {
    
                struct entry_point_command* mainCmd = (struct entry_point_command*)cur_seg_cmd;
                NSLog(@"find main");
                void* entry = (void*)(mainCmd->entryoff+(char*)header);
                NSLog(@"hook entry offset:%p",entry);
                MSHookFunction((void*)entry,(void*)&new_main,(void**)&orig_main);
                break;
            }
        }
        
    }
    
}
