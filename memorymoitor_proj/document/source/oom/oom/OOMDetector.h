//
//  OOMDetector.h
//  QQLeak
//
//  Created by rosen on 16/11/1.
//  Copyright © 2016年 tencent. All rights reserved.
//

#ifndef OOMDetector_h
#define OOMDetector_h

#import <Foundation/Foundation.h>

@interface OOMDetector : NSObject

+(OOMDetector *)getInstance;

-(BOOL)startOOMDetector:(NSTimeInterval)flushInterval threshHoldInbytes:(size_t)bytes;

-(void)stopOOMDetector;

-(void)flush_malloc_stack;

-(void)setMaxStackDepth:(size_t)depth;

-(NSString *)currentLogDir;

@end

#endif /* OOMDetector_h */
