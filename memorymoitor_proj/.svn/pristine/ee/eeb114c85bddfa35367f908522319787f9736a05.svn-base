//
//  main.m
//  FishHookTest
//
//  Created by kirk on 15/7/16.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <dlfcn.h>
#import "IOHook.h"

static void test()
{
    NSLog(@"etst");
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        enableIOHook();
        test();
        int fd = open(argv[0], O_RDONLY);
        uint32_t magic_number = 0;
        read(fd, &magic_number, 4);
        NSLog(@"Mach-O Magic Number: %x \n", magic_number);
        close(fd);
        
        fd = open(argv[0], O_RDONLY);
        magic_number = 0;
        read(fd, &magic_number, 4);
        NSLog(@"Mach-O Magic Number: %x \n", magic_number);
        close(fd);
        
//        disableIOHook();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
