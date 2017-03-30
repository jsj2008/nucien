//
//  ViewController.h
//  stacktarck
//
//  Created by michaelbi on 16/12/30.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#define RQD_MCONTEXT _STRUCT_MCONTEXT64
@interface ViewController : UIViewController

struct rqd_backtrace_t
{
    RQD_MCONTEXT mc;
    bool firsttag;
    void * frame;
    void * pc;
    void * lr;
    int step;
};

@end

