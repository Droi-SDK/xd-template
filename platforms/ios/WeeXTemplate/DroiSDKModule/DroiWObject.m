//
//  DroiWObject.m
//  WeeXTemplate
//
//  Created by Jon on 2017/10/9.
//  Copyright © 2017年 droi. All rights reserved.
//
#import <DroiCoreSDK/DroiCoreSDK.h>
#import "DroiWObject.h"

@implementation DroiWObject
WX_EXPORT_METHOD(@selector(save:body:jsCallback:))

- (void)save:(NSString *)tableName body:(NSString *)body jsCallback:(WXModuleCallback)jsCallback{
    NSLog(@"%@---%@",tableName,body);
}

+ (DroiObject *)droiObjectFromJson:(NSDictionary *)jsonDict tableName:(NSString *)tableName{
    DroiObject *obj = [DroiObject createWithClassName:tableName];
    for (NSString *key in [jsonDict allKeys]) {
        id value = [jsonDict valueForKey:key];
        if([value isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)value allKeys] containsObject:@"_DataType"]){
            NSDictionary *valueDict = (NSDictionary *)value;
            NSDictionary *objectDict = [valueDict valueForKey:@"_Object"];
            if(objectDict){
                NSString *myTableName = [valueDict valueForKey:@"_TableName"];
                DroiReferenceObject *referenceObj = [DroiReferenceObject new];
                if([myTableName isEqualToString:@"_File"]){
                    DroiFile *droiFile = [self droiFileFromJson:nil];
                }else if ([myTableName isEqualToString:@"_User"]){
                    
                }else{
                    
                }
            }
        }
    }
    return obj;
}

+ (DroiFile *)droiFileFromJson:(NSDictionary *)jsonDict{
    NSString *filePath = [jsonDict valueForKey:@"filePath"];
    
    return nil;
}
@end
