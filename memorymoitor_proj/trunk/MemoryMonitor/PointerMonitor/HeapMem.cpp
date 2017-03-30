//
//  HeapMem.cpp
//  MemoryMonitor
//
//  Created by michaelbi on 17/3/4.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#include "HeapMem.h"


static kern_return_t memory_reader(task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

void HeapMem::check_ptr_in_vmrange(vm_range_t range){
    const uint32_t align_size =sizeof(void *);
    vm_address_t vm_addr = range.address;
    vm_size_t vm_size = range.size;
    vm_size_t end_addr =vm_addr +vm_size;
    if(align_size <=vm_size){
        uint8_t * ptr_addr =(uint8_t *)vm_addr;
        for(uint64_t addr =vm_addr;addr <end_addr &&((end_addr-addr)>=align_size);addr+=align_size,ptr_addr +=align_size){
            vm_address_t *dest_ptr =(vm_address_t*)ptr_addr;
            printf("dest_ptr %p -- Class: \n",dest_ptr);
        }
    }
}


void HeapMem::CheckPtrInHeap(task_t task, void * baton, unsigned type, vm_range_t * ptrs, unsigned count) {
    HeapMem *heapMemory=(HeapMem *)baton;
    //info={6,check_ptr_in_vmrange};
    while(count--){
        vm_range_t range ={ptrs->address,ptrs->size};
        heapMemory->check_ptr_in_vmrange(range);
    }
    ptrs++;
}


int getHeapPointer() {
    
    //internalClassList = objc_copyClassList(&classCount);
    //    for(int i = 0; i < classCount; ++i) {
    //        NSLog(@"ClassList : %@\n", internalClassList[i]);
    //    }
    //updateRegisteredClasses();
    vm_address_t *zones = NULL;
    uint64_t count = 0;
    HeapMem *heapMemory = new HeapMem();
    //kern_return_t error = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &count);
    kern_return_t error = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &count);
    if (error == KERN_SUCCESS) {
        for (uint64_t index = 0; index < count; index++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[index];
            if (zone->introspect && zone->introspect->enumerator) {
                zone->introspect->enumerator(mach_task_self(), NULL, MALLOC_PTR_IN_USE_RANGE_TYPE, zone, &memory_reader, &heapMemory->CheckPtrInHeap);
            }
        }
    }
    return 0;
}
