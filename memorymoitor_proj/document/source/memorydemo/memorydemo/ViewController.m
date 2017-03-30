//
//  ViewController.m
//  memorydemo
//
//  Created by michaelbi on 16/10/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "ViewController.h"
#import "twocontroller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect huge = CGRectMake(50,50,300,50);
    [button1 setFrame:huge];
    [button1 setTitle:@"增加一个alloc申请" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(jump2two:)forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    self.navigationItem.title=@"FBAllocationTracker测试界面";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"真实返回"
                                                        style: UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(btnClik:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(btnClik:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnClik:(UIButton*)sender
{
    NSLog(@"他摸了我");
    
}

-(void)jump2two:(UIButton*)sender
{
    twocontroller * two = [[twocontroller alloc]init];
    [self.navigationController pushViewController:two animated:YES];
    
}

@end
