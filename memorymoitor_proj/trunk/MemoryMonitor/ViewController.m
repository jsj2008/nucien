//
//  ViewController.m
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/1/15.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import "ViewController.h"
#include <malloc/malloc.h>
#import "StackMemory.h"
#import "HeapMemory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"%@",[StackMemory bs_backtraceOfMainThread]);
    [super viewDidLoad];
    [self test];
    [self app];
    //getHeapPointer(1, 2);
    // Do  additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test{
    NSObject* test = [[NSObject alloc]init];
    NSObject *test2 =[[NSObject alloc]init];
    //NSMutableString* test = [[NSMutableString alloc]initWithFormat:@"abcde"];
    malloc_printf("test - frist : %p\n", test);
    //NSMutableString* test2 = [[NSMutableString alloc]initWithFormat:@"cde"];
    malloc_printf("test2 : %p\n", test2);
    test=test2;
    malloc_printf("test - frist : %p\n", test);
    NSObject* test3=test2;
    test=test3;
    malloc_printf("test - frist : %p\n", test);
     getHeapPointer();
    //char *a = malloc(sizeof(char) * 1024);
    //malloc_printf("test  : 0x%016x\n", test);
//    malloc_printf("test2 : 0x%016x\n", test2);
//    malloc_printf("a     : 0x%016x\n", a);
//    free(a);
    //[test release];
    //[test2 release];
}

-(void)app{
    malloc_printf("end");
}
@end
