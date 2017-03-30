//
//  ViewController.m
//  oom
//
//  Created by michaelbi on 16/11/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#include <objc/objc-api.h>
#include <objc/runtime.h>
#include <malloc/malloc.h>
#include <mach/mach.h>
@interface ViewController ()

@end

@implementation ViewController

static Class * internalClassList;
static uint64_t classCount;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
