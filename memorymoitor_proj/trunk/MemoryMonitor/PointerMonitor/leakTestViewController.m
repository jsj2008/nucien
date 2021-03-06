//
//  leakTestViewController.m
//  MemoryMonitor
//
//  Created by michaelbi on 17/3/3.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import "leakTestViewController.h"
#include "HeapMemory.h"
#import "StackMemory.h"
#import "ViewController.h"
#import "PointerManager.h"
#import "BasicFunction.h"

static NSObject *global_a;

@implementation leakTestViewController

- (void)foo {
//    global_a = [[NSObject alloc]init];
//    malloc_printf("global_pointer: %p\n", global_a);
//    global_a = [[NSObject alloc]init];
//    malloc_printf("global_pointer2: %p\n", global_a);
    [self bar];
}

- (void)bar {
    NSMutableString* test1 = [[NSMutableString alloc]initWithFormat:@"cde"];
    malloc_printf("test1 : %p, %p\n", &test1, test1);
    NSMutableString* test2 = [[NSMutableString alloc]initWithFormat:@"ade"];
    malloc_printf("test2 : %p, %p\n", &test2, test2);
    test1 = test2;
    while (true) {
        ;
    }
}



-(void)loadView{
    int tmp = 10086;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        sleep(5);
        //suspendThread();
        stopMonitor();
        [PointerManager checkLeak];
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        sleep(5);
//        NSLog(@"LOW TO SUSPEND");
//        checkLeak();
//    });
//    sleep(4);
//    NSLog(@"MAIN THREAD SUSPEND");
    [super loadView];
    [self makeLeak];
    //malloc_printf("end\n");
    //getHeapPointer();
    }

-(void)makeLeakTrue{
    NSObject        *leakobj    = [[NSObject alloc]init];
    UIImage         *leakImage  = [[UIImage imageNamed:@"test.jpg"] retain];
    NSArray         *array      = [[NSArray alloc] initWithObjects:@"leak", @"leak", nil];
    NSDictionary     *dic        = [[NSDictionary alloc] initWithObjectsAndKeys:@"leak", @"leak", nil];
    NSSet           *set        = [[NSSet alloc] initWithObjects:@"leak", nil];
    NSData          *data       = [[NSData dataWithBytes:"leakObj" length:sizeof("leakObj")] retain];
    NSMutableString  *str        = [[NSMutableString alloc] initWithFormat:@"leakObj"];
    ViewController   *vc         = [[ViewController alloc] init];
    void *ptr = malloc(64);
    int a = 1;
    void (^block)() = ^{
        malloc_printf("Im a leak block %d\n", a);
    };
    void (^heap_block)() = Block_copy(block);
    malloc_printf("Leakobj\n obj: %p\n image: %p\n array: %p\n dic: %p\n set: %p\n myData: %p\n str: %p\n myVC: %p\n myMalloc: %p\n block: %p\n",
                  leakobj, leakImage, array, dic, set, data, str, vc, ptr, heap_block);
    block_address = heap_block;

}

-(void)makeLeak{
    [self makeLeakTrue];
//    NSObject        *leakobj    = [[NSObject alloc]init];
//    UIImage         *leakImage  = [[UIImage imageNamed:@"test.jpg"] retain];
//    NSArray         *array      = [[NSArray alloc] initWithObjects:@"leak", @"leak", nil];
//    NSDictionary    *dic        = [[NSDictionary alloc] initWithObjectsAndKeys:@"leak", @"leak", nil];
//    NSSet           *set        = [[NSSet alloc] initWithObjects:@"leak", nil];
//    NSData          *data       = [[NSData dataWithBytes:"leakObj" length:sizeof("leakObj")] retain];
//    NSMutableString *str        = [[NSMutableString alloc] initWithFormat:@"leakObj"];
//    ViewController  *vc         = [[ViewController alloc] init];
//    void *ptr = malloc(64);
//    int a = 1;
//    void (^block)() = ^{
//        malloc_printf("Im a leak block %d\n", a);
//    };
//    void (^heap_block)() = Block_copy(block);
//    malloc_printf("Leakobj\n obj: %p\n image: %p\n array: %p\n dic: %p\n set: %p\n data: %p\n str: %p\n myVC: %p\n malloc: %p\n block: %p\n",
//                  leakobj, leakImage, array, dic, set, data, str, vc, ptr, heap_block);
    [self foo];
//    malloc_printf("leakobj : %p\n", leakobj);
//    malloc_printf("test2 : %p\n", test2);
    //sleep(20);
    //while(1);
}

@end

