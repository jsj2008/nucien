//
//  ViewController.m
//  BSBacktraceLogger
//
//  Created by 张星宇 on 16/8/26.
//  Copyright © 2016年 bestswifter. All rights reserved.
//



#import "ViewController.h"
#import "BSBacktraceLogger.h"
#import "testa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)foo {
//    testa *TESTA = [[testa alloc] init];
//    int shit =999;
//    int holyshit =1010;
//    int doubleholyshit =1030;
//    int aaa =1011;
//    int bbb =1032;
//    int ccc =1013;
//    int ddd =1034;
//    printf("shit is :%lu\n",&shit);
//    printf("holyshit is :%lu\n",&holyshit);
//    printf("doubleholyshit is :%lu\n",&doubleholyshit);
//    printf("aaa is :%lu\n",&aaa);
//    printf("bbb is :%lu\n",&bbb);
//    printf("ccc is :%lu\n",&ccc);
//    printf("ddd is :%lu\n",&ddd);
    
    [self bar];
}

- (void)bar {
    //int barshit =1080;
    //int barholyshit =1080;
    //printf("barshit is :%lu\n",&barshit);
    //printf("barholyshit is :%lu\n",&barholyshit);
    while (true) {
        ;
    }
//    sleep(5000);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BSLOG_MAIN  // 打印主线程调用栈， BSLOG 打印当前线程，BSLOG_ALL 打印所有线程
        // 调用 [BSBacktraceLogger bs_backtraceOfCurrentThread] 这一系列的方法可以获取字符串，然后选择上传服务器或者其他处理。
    });
    //int a=1111;
    //int b=2222;
    //printf("a is :%lu\n",&a);
    //printf("b is :%lu\n",&b);
    [self foo];
}

@end
