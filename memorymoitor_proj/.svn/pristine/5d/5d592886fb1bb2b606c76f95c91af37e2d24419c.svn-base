//
//  FileCache.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/26.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MgnfFileCache : NSObject
{
    NSMutableArray* m_itemCaches;
    int m_type;
}

- (id)initWithType:(int)type;
- (void)addItem:(NSString*)item;
-(NSString*)writeToDisk;
-(NSInteger)count;
-(void)removeAllObject;

@end
