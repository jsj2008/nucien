//
//  HeapMem.hpp
//  MemoryMonitor
//
//  Created by michaelbi on 17/3/4.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#ifndef HeapMem_hpp
#define HeapMem_hpp

#include <stdio.h>
#include <malloc/malloc.h>
#include <mach/mach.h>
#include <assert.h>
#include <ctype.h>
#include <dlfcn.h>
#include <mach/mach_vm.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <objc/objc-api.h>
#include <objc/runtime.h>



class HeapMem
{
public:
    int getHeapPointer();
    void check_ptr_in_vmrange(vm_range_t abc);
    void CheckPtrInHeap(task_t task, void * baton, unsigned type, vm_range_t * ptrs, unsigned count);
};

#endif /* HeapMem_hpp */
