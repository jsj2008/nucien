//
//  TableViewController.m
//  memorydemo
//
//  Created by michaelbi on 16/10/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "TableViewController.h"
#import "twocontroller.h"
#import "summaryTableViewController.h"
#import "generationViewController.h"
#import "AppDelegate.h"



@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end
static NSMutableArray *staticarray;
@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate =self;
    tableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    NSThread *current = [NSThread currentThread];
    NSLog(@"main thread is %@",current);
    NSString *abc =@"aa";
    NSMutableArray *TT = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define changliang 137


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0){
        return 2;
    }else if (section==1){
        return 3;
    }else if (section==2){
        return 2;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
        if (0 == indexPath.section) { // 第0组
            if (0 == indexPath.row) // 第0组第0行
            {
                cell.textLabel.text = @"alloc hook";
                UISwitch* switchImage = [[UISwitch alloc] init];
                cell.accessoryView = switchImage;
                [switchImage addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
            }else if (1 == indexPath.row) // 第0组第1行
            {
                cell.textLabel.text = @"malloc hook";
                UISwitch* switchImage = [[UISwitch alloc] init];
                cell.accessoryView = switchImage;
                [switchImage addTarget:self action:@selector(switchOnmalloc:) forControlEvents:UIControlEventValueChanged];

            }
        }
    if (1 == indexPath.section) { // 第1组
        if (0 == indexPath.row) // 第1组第0行
        {
            cell.textLabel.text = @"Make Generation";
            UILabel *label = [[UILabel alloc]init];
            label.tag =101;
            label.text=@"0 ";
//            label.font = [UIFont boldSystemFontOfSize:15];
            [label sizeToFit];
            

//            CGFloat height = size.height;
//            label.backgroundColor = [UIColor clearColor];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                label.frame =CGRectMake(width - label.frame.size.width - 20.0,\
                                        12, label.frame.size.width, label.frame.size.height);
            } else {
               // label.frame =CGRectMake(cell.frame.size.width - label.frame.size.width - 20,\
                                        12, label.frame.size.width, label.frame.size.height);
            }
            [cell.contentView addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor grayColor];
            
        }else if (1 == indexPath.row) // 第1组第1行
        {
            cell.textLabel.text = @"look Summary";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (2 == indexPath.row) // 第1组第2行
        {
            cell.textLabel.text = @"look generation";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (2 == indexPath.section) { // 第2组
        if (0 == indexPath.row) // 第2组第0行
        {
            UIStepper *step =[[UIStepper alloc]init];
            step.minimumValue =0.0;
            step.value =0.0;
            [step addTarget:self action:@selector(stepTag:)forControlEvents:UIControlEventValueChanged];
            step.frame = CGRectMake(width - step.frame.size.width - 20.0,12, step.frame.size.width, step.frame.size.height);
            cell.textLabel.text = @"alloc/dealloc static object";
            UILabel *label2 = [[UILabel alloc]init];
            label2.tag =102;
            NSLog(@"the number is %lu",(unsigned long)[staticarray count]);
            label2.text=[NSString stringWithFormat:@"%lu",(unsigned long)[staticarray count]];
            [label2 sizeToFit];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [UIColor grayColor];
            label2.frame =CGRectMake(width - label2.frame.size.width - 150.0,\
                                    12, label2.frame.size.width, label2.frame.size.height);
            [cell addSubview:label2];
            [cell addSubview:step];
        }
        if (1 == indexPath.row) // 第2组第1行
        {
            cell.textLabel.text = @"dump memory";
        }
    }
    
    return cell;
}

-(void)switchOn:(UISwitch *)sender
{
    if(sender.isOn){
        [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] enableGenerations];
        NSLog(@"开关开启");
    }else{
        [[FBAllocationTrackerManager sharedManager] stopTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] disableGenerations];
        NSLog(@"开关关闭");
    }
    
}

-(void)switchOnmalloc:(UISwitch *)sender
{
    if(sender.isOn){
        turnOnMallocTracker();
        NSLog(@"开关开启");
    }else{
        turnOffMallocTracker();
        NSLog(@"开关关闭");
    }
    
}

- (void)stepTag:(UIStepper *)stepper {
    if(!staticarray){
        staticarray =[[NSMutableArray alloc] init];
    }
    while((double)[staticarray count]<stepper.value){
        twocontroller * two = [[twocontroller alloc]init];
        [staticarray addObject:two];
        UITableViewCell *cell = (UITableViewCell *)[[stepper superview] superview];
        UILabel *label = (UILabel *)[cell viewWithTag:102];
        label.text=[NSString stringWithFormat:@"%lu",(unsigned long)[staticarray count]];
        NSLog(@"steper alloc staticarray size is %li",(long)[staticarray count]);
    }
    while((double)[staticarray count]>stepper.value){
        if([staticarray count]){
            [staticarray removeLastObject];
            UITableViewCell *cell = (UITableViewCell *)[[stepper superview] superview];
            UILabel *label = (UILabel *)[cell viewWithTag:102];
            label.text=[NSString stringWithFormat:@"%lu",(unsigned long)[staticarray count]];
            NSLog(@"steper dalloc staticarray size is %li",(long)[staticarray count]);
        }
    }
    [self.view reloadInputViews];
    

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) { // 第1组
        if (0 == indexPath.row) // 第1组第0行
        {
             UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
             UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
            int intString = [label.text intValue];
            [[FBAllocationTrackerManager sharedManager] markGeneration];
            label.text = [NSString stringWithFormat:@"%d",++intString];
            [label sizeToFit];
            
            NSLog(@"%d",intString);
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView reloadData];
            [self.view reloadInputViews];
            
        }else if (1 == indexPath.row) // 第1组第1行
        {
//            twocontroller * two = [[twocontroller alloc]init];
//            [two.view setBackgroundColor:[UIColor whiteColor]];
            
            NSArray *arr = [[FBAllocationTrackerManager sharedManager] currentAllocationSummary];
            summaryTableViewController * summary =[[summaryTableViewController alloc]init];
            summary.array=arr;
//            summary.isSomethingEnabled= YES;
            NSLog(@"%lu",(unsigned long)[arr count]);
            [self.navigationController pushViewController:summary animated:YES];
        }else if (2 == indexPath.row) // 第1组第2行
        {
            NSArray *arr = [[FBAllocationTrackerManager sharedManager] currentSummaryForGenerations];
            generationViewController * generationsummary =[[generationViewController alloc]init];
            generationsummary.array=arr;
            NSLog(@"%lu",(unsigned long)[arr count]);
            [self.navigationController pushViewController:generationsummary animated:YES];
        }
    }
    if (2 == indexPath.section) { // 第2组
        if (0 == indexPath.row) // 第2组第0行
        {
            if(!staticarray){
                staticarray =[[NSMutableArray alloc] init];
            }
            
            twocontroller * two = [[twocontroller alloc]init];
            [staticarray addObject:two];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell viewWithTag:102];
            label.text=[NSString stringWithFormat:@"%lu",(unsigned long)[staticarray count]];
            NSLog(@"label.text is %@",label.text);
            [self.view reloadInputViews];
            NSLog(@"alloc staticarray size is %li",(long)[staticarray count]);
        }
        if (1 == indexPath.row) // 第2组第1行
        {
            NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [path1 objectAtIndex:0];
            NSString *filePath = [path stringByAppendingString:@"/stackinfo.txt"];
            NSString *ctx = @"";
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:filePath]) {
                [fileManager createFileAtPath:filePath contents:nil attributes:nil];
            }
            void *ptrs_hashmap = getMap();
            //morefunction = 1;
            int cttt = 0;
            int length = hashmap_get_length(ptrs_hashmap);
            int idx;
            for(idx = 0; idx < length; ++idx)
            {
                void *tmp0 = hashmap_return_with_index(ptrs_hashmap, idx);
                if((int)tmp0 != -3)
                {
                    cttt ++;
                    base_ptr_t *tmp = tmp0;
                    ctx = [ctx stringByAppendingFormat:@"stack address 0x%lx with size %d.\n", tmp->address, tmp->size];
                    int j;
                    for(j = 0; j < tmp->depth; ++j)
                    {
                        StackImage image;
                        long addr = (long)tmp->stack[j];
                        getImageByAddr(addr, &image);
                        //sprintf(info, "\"%d %s 0x%lx 0x%lx\",",(int)i, (namett != NULL) ? namett : "unknown", image.loadAddr, addr);
                        ctx = [ctx stringByAppendingFormat:@"\"%d %s 0x%lx 0x%lx\",\n", j, image.name, image.loadAddr, addr];
                        
                    }
                }
                
            }
            [ctx writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    [self.view reloadInputViews];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    if (0 == section) {
//        return @"德系品牌";
//    }else{
//        return @"日韩品牌";
//    }
//}
@end
