//
//  TableViewController.h
//  memorydemo
//
//  Created by michaelbi on 16/10/9.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBAllocationTracker/FBAllocationTrackerManager.h"
#import "mallochook.h"
@interface TableViewController : UIViewController
@property (nonatomic, retain) NSMutableArray * array;
@end
