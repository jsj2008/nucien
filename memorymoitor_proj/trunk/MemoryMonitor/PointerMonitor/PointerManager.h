//
//  Header.h
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/3/10.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

#import "BasicFunction.h"

@interface PointerManager : NSObject
+(void)checkLeak;
+(NSMutableArray*) vm_address_tToNSArray:(vm_address_t **)stack Depth:(uint32_t)depth;
@end

extern void *block_address;

void ptrCheck(uint64_t ptr);
//void checkLeak();
