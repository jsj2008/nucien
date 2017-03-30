//
//  summaryTableViewController.h
//  memorydemo
//
//  Created by michaelbi on 16/10/10.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "twocontroller.h"
#import "FBAllocationTracker/FBAllocationTrackerManager.h"
#import "FBAllocationTracker/FBAllocationTrackerSummary.h"
@interface summaryTableViewController : UITableViewController

@property (nonatomic, assign) BOOL *isSomethingEnabled;
@property (nonatomic, retain) NSArray *array;
@end
