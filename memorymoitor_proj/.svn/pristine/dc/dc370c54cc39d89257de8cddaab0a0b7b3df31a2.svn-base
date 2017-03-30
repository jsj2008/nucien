//
//  summaryTableViewController.m
//  memorydemo
//
//  Created by michaelbi on 16/10/10.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "summaryTableViewController.h"
#import "instanceOfClass.h"

@interface summaryTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation summaryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate =self;
    tableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"self arr count is %ld",[self.array count]);
    
    return [self.array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    FBAllocationTrackerSummary* Summary = [self.array objectAtIndex: indexPath.section];
    UILabel *label = [[UILabel alloc]init];
    
//    twocontroller * two = [[twocontroller alloc]init];
//    twocontroller * three = [[twocontroller alloc]init];
//    NSArray *abc =[[NSArray alloc]init];
//    NSMutableArray *acc =[[NSMutableArray alloc]init];
//    NSString *string = @"this is string";
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    //            CGFloat height = size.height;
    //            label.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        label.frame =CGRectMake(width - label.frame.size.width - 300.0,\
                                28, label.frame.size.width, label.frame.size.height);
    } else {
        // label.frame =CGRectMake(cell.frame.size.width - label.frame.size.width - 20,\
        12, label.frame.size.width, label.frame.size.height);
    }
    
    
    cell.textLabel.text=Summary.className;
    label.text = [NSString stringWithFormat:@"alloc: %li dealloc: %li alive: %li size:%li",
                  Summary.allocations,
                  Summary.deallocations,
                  Summary.aliveObjects,
                  Summary.instanceSize];
    NSLog(@"classname is  %@ alloc: %li dealloc: %li alive: %li size:%li",
          Summary.className,
           Summary.allocations,
           Summary.deallocations,
           Summary.aliveObjects,
           Summary.instanceSize);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    [cell.contentView addSubview:label];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBAllocationTrackerSummary* Summary = [self.array objectAtIndex: indexPath.section];
    NSArray *classArray = [[NSArray alloc]initWithObjects:NSClassFromString(Summary.className), nil];
    instanceOfClass * instance =[[instanceOfClass alloc]init];
    NSArray *instancceArray = [[NSArray alloc] initWithArray:[[FBAllocationTrackerManager sharedManager] instancesOfClasses:classArray]];
    instance.array = instancceArray;
    [self.navigationController pushViewController:instance animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
