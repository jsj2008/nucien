//
//  mallochook.h
//  memorydemo
//
//  Created by michaelbi on 16/10/11.
//  Copyright © 2016年 tencent. All rights reserved.
//



#include "imageStackinfo.h"
#include "hashmap.h"
#import "fishhook.h"
void turnOnMallocTracker(void);
void turnOffMallocTracker(void);
void my_free(void *ptr, const void *caller);
void *my_malloc (size_t size, const void *caller);
typedef struct
{
    uint32_t size;
    uint32_t depth;
    vm_address_t **stack;
    char name[16];
    vm_address_t address;
}base_ptr_t;

map_t ptrs_hashmap;
