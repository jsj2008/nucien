
//
//  yellowHookTool.h
//  QQMSFContact
//
//  Created by rosenluo on 15/7/22.
//
//

#import <Foundation/Foundation.h>

@interface YellowHookTool : NSObject

+ (void)swizzleInstanceMethod:(Class)origCls selector:(SEL)origSel withClass:(Class)repCls Method:(SEL)repSel;

+ (void)swizzleClassMethod:(Class)origCls selector:(SEL)origSel withClass:(Class)repCls Method:(SEL)repSel;

@end
