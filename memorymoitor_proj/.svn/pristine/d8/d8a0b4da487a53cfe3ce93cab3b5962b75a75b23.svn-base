//
//  HeapMemory.m
//  MIO
//
//  Created by 王哲锴 on 17/1/15.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import "HeapMemory.h"



static Class * internalClassList;
static uint64_t classCount;
static CFMutableSetRef registeredClasses;

typedef struct {
    Class isa;
} flex_maybe_object_t;

typedef void zone_callback_t(vm_range_t range);

typedef struct range_callback_info_t
{
    int a;
    zone_callback_t *range_callback;
} range_callback_info;



static kern_return_t memory_reader(task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

void updateRegisteredClasses(){
    if (!registeredClasses) {
        registeredClasses = CFSetCreateMutable(NULL, 0, NULL);
    } else {
        CFSetRemoveAllValues(registeredClasses);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(registeredClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
}

void CanHasObjects(task_t task, void * context, unsigned type, vm_range_t * addr, unsigned count) {
    for (uint64_t index = 0; index < count; index++) {
        vm_range_t range =  addr[index];
        flex_maybe_object_t *address = ((flex_maybe_object_t *)range.address);
        size_t size = range.size;
        if (size >= sizeof(Class) && address != NULL) {
            for (uint64_t lookupIndex = 0; lookupIndex < classCount; lookupIndex++) {
                Class testClass = (internalClassList[lookupIndex]);
                Class tryClass = NULL;
#ifdef __arm64__
                extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
                tryClass = (__bridge Class)((void *)((uint64_t)address->isa & objc_debug_isa_class_mask));
#else
                tryClass = address->isa;
#endif
                if (CFSetContainsValue(registeredClasses, (__bridge const void *)(tryClass))) {
                    malloc_printf("%p -- Class: %s\n",address, object_getClassName((__bridge id)address));
                    break;
                }
//                if (tryClass == testClass) {
//                    printf("0x%016x -- Class: %s\n",address, object_getClassName((__bridge id)address));
//                    break;
//                }
            }
        }
    }
}


void check_ptr_in_vmrange(vm_range_t range){
    const uint32_t align_size =sizeof(void *);
    vm_address_t vm_addr = range.address;
    vm_size_t vm_size = range.size;
    vm_size_t end_addr =vm_addr +vm_size;
    if(align_size <=vm_size){
        uint8_t * ptr_addr =(uint8_t *)vm_addr;
        for(uint64_t addr =vm_addr;addr <end_addr &&((end_addr-addr)>=align_size);addr+=align_size,ptr_addr +=align_size){
            vm_address_t *dest_ptr =(vm_address_t*)ptr_addr;
            malloc_printf("HeapMemory Pointer, Value: %p, %p\n", dest_ptr, *dest_ptr);
            ptrCheck(*dest_ptr);
        }
    }
}


void CheckPtrInHeap(task_t task, void * baton, unsigned type, vm_range_t * ptrs, unsigned count) {
    while(count--){
        vm_range_t range ={ptrs->address,ptrs->size};
        check_ptr_in_vmrange(range);
        ptrs++;
    }
    
}


int getHeapPointer() {
    internalClassList = objc_copyClassList(&classCount);
//    for(int i = 0; i < classCount; ++i) {
//        NSLog(@"ClassList : %@\n", internalClassList[i]);
//    }
    updateRegisteredClasses();
    vm_address_t *zones = NULL;
    uint64_t count = 0;
    //kern_return_t error = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &count);
    kern_return_t error = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &count);
    if (error == KERN_SUCCESS) {
        for (uint64_t index = 0; index < count; index++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[index];
            if (zone != NULL&& !zone->reserved1 && !zone->reserved2 // if reserved1 and reserved2 are not NULL, zone object is corrupted
                && zone->introspect != NULL && zone->introspect->enumerator != NULL){
                zone->introspect->enumerator(mach_task_self(), NULL, MALLOC_PTR_IN_USE_RANGE_TYPE, zone, &memory_reader, &CheckPtrInHeap);
            }
        }
    }
    return 0;
}



//+ (void)enumerateLiveObjectsUsingBlock:(flex_object_enumeration_block_t)block
//{
//    if (!block) {
//        return;
//    }
//    
//    // Refresh the class list on every call in case classes are added to the runtime.
//    [self updateRegisteredClasses];
//    
//    // For another exmple of enumerating through malloc ranges (which helped my understanding of the api) see:
//    // http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/examples/darwin/heap_find/heap/heap_find.cpp
//    // Also https://gist.github.com/samdmarshall/17f4e66b5e2e579fd396
//    vm_address_t *zones = NULL;
//    unsigned int zoneCount = 0;
//    kern_return_t result = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &zoneCount);
//    if (result == KERN_SUCCESS) {
//        for (unsigned int i = 0; i < zoneCount; i++) {
//            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
//            if (zone->introspect && zone->introspect->enumerator) {
//                zone->introspect->enumerator(mach_task_self(), (__bridge void *)(block), MALLOC_PTR_IN_USE_RANGE_TYPE, zones[i], &memory_reader, &range_callback);
//            }
//        }
//    }
//}

//
//static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount)
//{
//    flex_object_enumeration_block_t block = (__bridge flex_object_enumeration_block_t)context;
//    if (!block) {
//        return;
//    }
//    
//    for (unsigned int i = 0; i < rangeCount; i++) {
//        vm_range_t range = ranges[i];
//        flex_maybe_object_t *tryObject = (flex_maybe_object_t *)range.address;
//        Class tryClass = NULL;
//#ifdef __arm64__
//        // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
//        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
//        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
//#else
//        tryClass = tryObject->isa;
//#endif
//        // If the class pointer matches one in our set of class pointers from the runtime, then we should have an object.
//        if (CFSetContainsValue(registeredClasses, (__bridge const void *)(tryClass))) {
//            block((__bridge id)tryObject, tryClass);
//        }
//    }
//}
