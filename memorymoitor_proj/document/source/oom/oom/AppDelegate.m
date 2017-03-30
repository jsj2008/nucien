//
//  AppDelegate.m
//  oom
//
//  Created by michaelbi on 16/11/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#include <objc/objc-api.h>
#include <objc/runtime.h>
#include <malloc/malloc.h>
#include <mach/mach.h>

@interface AppDelegate ()

@end

static Class * internalClassList;
static uint64_t classCount;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    intt(1,2);
    // Override point for customization after application launch.
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
typedef struct {
    Class isa;
} flex_maybe_object_t;

static Class * internalClassList;
static uint64_t classCount;

void CanHasObjects(task_t task, void * context, unsigned type, vm_range_t * addr, unsigned count) {
    for (uint64_t index = 0; index < count; index++) {
        vm_range_t range =  addr[index];
        flex_maybe_object_t *address = ((flex_maybe_object_t *)range.address);
        size_t size = range.size;
        if (size >= sizeof(Class) && address != NULL) {
            for (uint64_t lookupIndex = 0; lookupIndex < classCount; lookupIndex++) {
                Class testClass = (internalClassList[lookupIndex]);
                if (address->isa == testClass) {
                    printf("0x%016x -- Class: %s\n",address, object_getClassName((__bridge id)address));
                    break;
                }
            }
        }
    }
}

int intt(int argc, const char * argv[]) {
    
    internalClassList = objc_copyClassList(&classCount);
    vm_address_t *zones;
    uint64_t count;
    kern_return_t error = malloc_get_all_zones(mach_task_self(), NULL, &zones, &count);
    if (error == KERN_SUCCESS) {
        for (uint64_t index = 0; index < count; index++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[index];
            if (zone != NULL && zone->introspect != NULL) {
                zone->introspect->enumerator(mach_task_self(), NULL, MALLOC_PTR_IN_USE_RANGE_TYPE, zone, NULL, &CanHasObjects);
            }
        }
    }
    return 0;
}

@end
