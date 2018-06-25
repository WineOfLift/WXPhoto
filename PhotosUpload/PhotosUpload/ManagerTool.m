
//
//  ManagerTool.m
//  photoDemo
//
//  Created by apple001 on 2018/6/25.
//  Copyright © 2018年 wangxinxu. All rights reserved.
//

#import "ManagerTool.h"
#define RAB(str)  [NSString stringWithFormat:@"http://121.40.188.122:8101/huba-api/%@?key=z1zkey&code=MTJCNDgyOTIxOTk4QjUzQzM2QTlFN0ZFMzY0MDNEMjQ=",str]


@implementation ManagerTool

#pragma mark - 判断字符串是否为空
+(NSString *)stringIsEmpty:(NSString *)str{
    
    NSString *string=[NSString stringWithFormat:@"%@",str];
    
    if ([string isEqualToString:@""]||[string isEqualToString:@"(null)"]||[string isEqualToString:@"<null>"]||string==nil||[string isEqual:[NSNull class]]) {
        
        string=@"";
    }
    return string;
}


#pragma mark ---for循环上传多张图片----
+(void)updatePhotos:(NSArray *)photos block:(void (^)(NSDictionary *))block fail:(void (^)(void))fail
{
    NSMutableArray * picArray = [NSMutableArray  array];
    for (int i = 0; i < photos.count; i ++) {
        int64_t delayInSeconds = i + 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // do something
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:RAB(@"add_file") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *imageData = photos[i];
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
                
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                NSLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString * url = responseObject[@"url"];
                NSLog(@"---输出一下此时的东西 = %@",responseObject);
                [picArray removeAllObjects];
                [picArray addObject:[ManagerTool  stringIsEmpty:url]];
                
                NSDictionary * toGetAllUrlDic = @{@"picUrl":picArray};
                block(toGetAllUrlDic);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSDictionary * toGetAllUrlDic = @{@"picUrl":picArray};
                block(toGetAllUrlDic);
                fail();
            }];
        });
    }
    
}

@end
