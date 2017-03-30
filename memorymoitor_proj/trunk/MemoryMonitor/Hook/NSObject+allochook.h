//
//  allochook.h
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/3/2.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllocHookTool.h"
#import "BasicFunction.h"

@interface NSObject(allochook)

+(void)swizzleMemoryMethod;

@end
