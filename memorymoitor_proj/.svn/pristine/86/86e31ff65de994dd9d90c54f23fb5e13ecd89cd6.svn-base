//
//  AppDelegate.m
//  MemoryMonitor
//
//  Created by 王哲锴 on 17/1/15.
//  Copyright © 2017年 王哲锴. All rights reserved.
//

#import "AppDelegate.h"
#import "HeapMemory.h"
#import "GlobalMemory.h"
#import "NSObject+allochook.h"
#import <Foundation/Foundation.h>
#import "StackMemory.h"
#include <objc/objc-api.h>
#include <objc/runtime.h>
#include <malloc/malloc.h>
#include <mach/mach.h>
#include "ViewController.h"
#include "mallochook.h"
#include "leakTestViewController.h"
#include "malloc_logger.h"
#import "PointerManager.h"
@interface AppDelegate ()

@end

int a = 11342;
int b = 11111;
int c = 22293;
int d = 22222;
int e = 99999;
int f = 11212;
int g = 2121212;
int h = 11111;
int iii = 12306;
char bbb = 'a';
char ccc = 'b';


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    hook_init();
    mainfunc();
    turnOnMallocTracker();
    [NSObject swizzleMemoryMethod];
    [GlobalMemory getGlobalVariableMemory];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    leakTestViewController *leaktest =[[leakTestViewController alloc] init];
    UINavigationController *navroot = [[UINavigationController alloc]initWithRootViewController:leaktest];
    self.window.rootViewController = navroot;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
