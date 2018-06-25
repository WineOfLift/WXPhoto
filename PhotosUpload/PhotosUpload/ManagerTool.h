//
//  ManagerTool.h
//  photoDemo
//
//  Created by apple001 on 2018/6/25.
//  Copyright © 2018年 wangxinxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface ManagerTool : NSObject
#pragma mark - 判断字符串是否为空
+(NSString *)stringIsEmpty:(NSString *)str;
#pragma mark ---for循环上传多张图片----
+(void)updatePhotos:(NSArray *)photos block:(void (^)(NSDictionary *))block fail:(void (^)(void))fail;
@end
