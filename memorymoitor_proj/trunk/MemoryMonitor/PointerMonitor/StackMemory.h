//
//  StackMemory.h
//  MIO
//
//  Created by 王哲锴 on 17/1/15.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#ifndef StackMemory_h
#define StackMemory_h


#endif /* StackMemory_h */

#import <Foundation/Foundation.h>
#import "PointerManager.h"

@interface StackMemory : NSObject

+ (NSString *)bs_backtraceOfAllThread;
+ (NSString *)bs_backtraceOfCurrentThread;
+ (NSString *)bs_backtraceOfMainThread;
+ (NSString *)bs_backtraceOfNSThread:(NSThread *)thread;

@end
