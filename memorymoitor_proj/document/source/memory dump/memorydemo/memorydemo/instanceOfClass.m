//
//  instanceOfClass.m
//  memorydemo
//
//  Created by michaelbi on 16/10/10.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "instanceOfClass.h"

@interface instanceOfClass ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation instanceOfClass

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate =self;
    tableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
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
    const char *instancename = object_getClassName([self.array objectAtIndex: indexPath.section]);
    cell.textLabel.text = [[NSString alloc] initWithCString:(const char*)instancename encoding:NSASCIIStringEncoding];    
    return cell;
}


//- (NSString *)nameWithInstance:(id)instance Class:(Class)class Instanceofclass:(id) instanceofclass
//{
//    unsigned int numIvars = 0;
//    NSString *key=nil;
//    Class cls = class;
//    Ivar * ivars = class_copyIvarList(cls, &numIvars);
//    for(int i = 0; i < numIvars; i++) {
//        Ivar thisIvar = ivars[i];
//        const char *type = ivar_getTypeEncoding(thisIvar);
//        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
//        if (![stringType hasPrefix:@"@"]) {
//            continue;
//        }
//        if ((object_getIvar(instanceofclass, thisIvar) == instance)) {
//            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
//            break;
//        }
//    }
//    free(ivars);
//    return key;
//    
//}
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
