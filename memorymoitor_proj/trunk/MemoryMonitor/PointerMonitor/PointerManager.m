//
//  GetPointer.m
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/3/10.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointerManager.h"
#import "ImageInfo.h"
void *block_address;
@implementation PointerManager
+(void)checkLeak{
    hashmap_map* m = (hashmap_map*) ptrs_hashmap;
    for(int i = 0; i < m->table_size; i++)
    {
        if(m->data[i].in_use == 0)
            continue;
        base_ptr_t *data = m->data[i].data;
        any_t tmp;
        malloc_printf("data: %p\n", data->address);
        if(hashmap_get(pmap, longToString(data->address), &tmp) == MAP_MISSING)
        {
            malloc_printf("Leak find : %p\n", data->address);
            NSMutableArray* ret =[ImageInfo getStackInfo:[self vm_address_tToNSArray:data->stack Depth:data->depth]];
            for (NSString *str in ret){
                char * chr = [str UTF8String];
                malloc_printf("stack : %s\n", chr);
            }
            
        }
    }
}

//void checkLeak()
//{
//    
//    hashmap_map* m = (hashmap_map*) ptrs_hashmap;
//    for(int i = 0; i < m->table_size; i++)
//    {
//        if(m->data[i].in_use == 0)
//            continue;
//        
//        base_ptr_t *data = m->data[i].data;
//        any_t tmp;
//        malloc_printf("data: %p\n", data->address);
//        if(hashmap_get(pmap, longToString(data->address), &tmp) == MAP_MISSING)
//        {
//            
//            malloc_printf("Leak find : %p\n", data->address);
//        }
//    }
//}

//-(NSMutableArray *)getStackInfo:(CallBackStack)callStack;
+(NSMutableArray*) vm_address_tToNSArray:(vm_address_t **)stack Depth:(uint32_t)depth{
    NSMutableArray * ret =[[NSMutableArray alloc]init];
    for(int i=0;i<depth;i++){
        //NSLog(@"Pointer: %p\n", stack[i]);
        NSNumber * cell=[NSNumber numberWithUnsignedLong:(unsigned long)stack[i]];
        [ret addObject:cell];
    }
    return ret;
    
}
@end

void ptrCheck(uint64_t ptr)
{
    uint64_t value;
    if(hashmap_get(ptrs_hashmap, longToString(ptr), &value) != MAP_MISSING)
    {
        hashmap_put(pmap, longToString(ptr), ptr);
    }
}

