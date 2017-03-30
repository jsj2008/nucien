//
//  HeapMemory.h
//  MIO
//
//  Created by 王哲锴 on 17/1/15.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#ifndef HeapMemory_h
#define HeapMemory_h


#endif /* HeapMemory_h */

#import <Foundation/Foundation.h>
#include <malloc/malloc.h>
#include <objc/objc-api.h>
#include <objc/runtime.h>
#include <mach/mach.h>
#import "PointerManager.h"

@interface HeapMemory : NSObject

@end

int getHeapPointer();
void check_ptr_in_vmrange(vm_range_t abc);
