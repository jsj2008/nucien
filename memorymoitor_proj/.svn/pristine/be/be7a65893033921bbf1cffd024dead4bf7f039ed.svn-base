//
//  IOHook.m
//  TabDemo
//
//  Created by jackyjiao on 7/9/15.
//  Copyright (c) 2015 jackyjiao. All rights reserved.
//


#import "IOHook.h"
#import <dlfcn.h>
#import "fishhook.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>


static int (*orig_close)(int);
static int (*orig_open)(const char *, int, ...);

void save_original_symbols() {
    orig_close = dlsym(RTLD_DEFAULT, "close");
    orig_open = dlsym(RTLD_DEFAULT, "open");
}

int my_open(const char *path, int oflag, ...) {
    va_list ap = {0};
    mode_t mode = 0;
    if ((oflag & O_CREAT) != 0) {
        // mode only applies to O_CREAT
        va_start(ap, oflag);
        mode = va_arg(ap, int);
        va_end(ap);
        NSLog(@"create('%s', %d, %d)\n", path, oflag, mode);
        return orig_open(path, oflag, mode);
    } else {
        NSLog(@"open('%s', %d)\n", path, oflag);
        return orig_open(path, oflag, mode);
    }
}

int my_close(int fd) {
    return orig_close(fd);
}


void enableIOHook()
{
    save_original_symbols();
    rebind_symbols((struct rebinding[2]){{"close", my_close}, {"open", my_open}}, 2);
}

void disableIOHook()
{
    rebind_symbols((struct rebinding[2]){{"close",orig_close}, {"open", orig_open}}, 2);
}
