//
//  NSThread+num.m
//  test
//
//  Created by kirk on 15/9/6.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "NSThread+Num.h"

@implementation NSThread(Num)
- (NSNumber*)sequenceNumber
{
    long num = [[self valueForKeyPath:@"private.seqNum"] integerValue];
    return [NSNumber numberWithLong:num];
}
@end
