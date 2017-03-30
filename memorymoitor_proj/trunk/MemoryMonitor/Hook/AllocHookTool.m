//
//  YellowHookTool.m
//  QQMSFContact
//
//  Created by rosenluo on 15/7/22.
//
//

#import "AllocHookTool.h"
#import <objc/runtime.h>


@implementation YellowHookTool

+ (void)swizzleInstanceMethod:(Class)origCls selector:(SEL)origSel withClass:(Class)repCls Method:(SEL)repSel
{
    Method rawMethod = class_getInstanceMethod(origCls, origSel);
    Method replacement = class_getInstanceMethod(repCls, repSel);
    
    method_exchangeImplementations(rawMethod, replacement);
}

+ (void)swizzleClassMethod:(Class)origCls selector:(SEL)origSel withClass:(Class)repCls Method:(SEL)repSel
{
    Method rawMethod = class_getClassMethod(origCls, origSel);
    Method replacement = class_getClassMethod(repCls, repSel);
    
    method_exchangeImplementations(rawMethod, replacement);
}

@end
