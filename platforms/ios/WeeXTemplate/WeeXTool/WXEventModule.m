//
//  WXEventModule.m
//  Muslim
//
//  Created by Jon on 2017/9/5.
//  Copyright © 2017年 Droi. All rights reserved.
//

#import "WXEventModule.h"

@implementation WXEventModule

WX_EXPORT_METHOD(@selector(test:))
WX_EXPORT_METHOD(@selector(test2:))
WX_EXPORT_METHOD(@selector(test3:arg2:))
WX_EXPORT_METHOD(@selector(test3:arg3:))
WX_EXPORT_METHOD(@selector(test3:arg3:arg4:))

- (void)test:(NSString *)string {
    NSLog(@"++++++++++++++++%@",string);
}

- (void)test2:(NSString *)string {
    NSLog(@"++++++++++++++++%@",string);
}

- (void)test3:(NSString *)str1 arg2:(NSString *)str2{
    NSLog(@"++++++++++++++++%@------------%@",str1,str2);
}

- (void)test3:(NSString *)str1 arg3:(NSString *)str2{
    NSLog(@"++++++++++++++++%@--********------%@",str1,str2);
}

- (void)test3:(NSString *)str1 arg3:(NSString *)str2 arg4:(NSString *)str3{
    NSLog(@"++++++++++++++++%@--********%@########------%@",str1,str2,str3);

}

@end
