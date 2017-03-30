//
//  twocontroller.m
//  memorydemo
//
//  Created by michaelbi on 16/10/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "twocontroller.h"

@implementation twocontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect huge = CGRectMake(0,50,600,50);
    [button1 setFrame:huge];
    [button1 setTitle:@"增加两个alloc申请" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnClik:)forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
  //  [self.view addSubview:button1];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"真实返回"
                                                                          style: UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(btnClik:)];
    twocontroller * two = [[twocontroller alloc]init];
    twocontroller * three = [[twocontroller alloc]init];
    NSArray *abc =[[NSArray alloc]init];
    NSMutableArray *acc =[[NSMutableArray alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.text=@"0";
    //            label.font = [UIFont boldSystemFontOfSize:15];
//    [label sizeToFit];
    label.frame = CGRectMake(0,50,300,50);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
//    NSArray *arr = [[FBAllocationTrackerManager sharedManager] currentAllocationSummary];
//    for (FBAllocationTrackerSummary* Summary in arr) {
//        if(true){ //Summary.allocations>=Summary.deallocations){
//            NSLog(@"*******************************************************************");
//            NSLog(@"summary className is %@",Summary.className);
//            NSLog(@"summary allocations num is %lu",(unsigned long)Summary.allocations);
//            NSLog(@"summary deallocations num is %lu",(unsigned long)Summary.deallocations);
//            NSLog(@"summary aliveObjects num is %lu",(unsigned long)Summary.aliveObjects);
//            NSLog(@"summary instanceSize num is %lu",(unsigned long)Summary.instanceSize);
//            if ([Summary.className isEqualToString:@"twocontroller"]){
//                [label setText:[NSString stringWithFormat:@"内存中有实例%lu个,申请了%lu个，销毁了%lu个",
//                                    Summary.aliveObjects,
//                                    Summary.allocations,
//                                    Summary.deallocations]];
//                [label sizeToFit];
//                label.frame = CGRectMake(10,100,label.frame.size.width,label.frame.size.height);
//            }
//        }
//    }
//    NSLog(@"arr size is %ld",[arr count]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnClik:(UIButton*)sender
{
    NSLog(@"他摸了我");
    
}

@end
