//
//  BaseHTTPManager.m
//  MyHealthy
//
//  Created by 薛飞龙 on 15/10/12.
//  Copyright © 2015年 Flonger. All rights reserved.
//

#import "BaseHTTPManager.h"

@implementation BaseHTTPManager


+ (void)GET:(NSString *)APIString parameters:(NSMutableArray *)parameters
    success:(void (^)(AFHTTPRequestOperation *, id))success
    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{

    
    
    //拼接URL
    NSMutableString *url = [NSMutableString new];
    
    [url appendString:TG_API_DOMAIN];
    [url appendString:APIString];
    
    int counter = 0;
    
    for (NSDictionary *dic in parameters) {
        NSString *key = [NSString stringWithFormat:@"%@",[dic objectForKey:API_PARAM_KEY]];
        NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:API_PARAM_VALUE]];
        //                    value = [value encodeURL];
        
        [url appendString:key];
        [url appendString:@"="];
        [url appendString:value];
        
        if (counter != ([parameters count] -1)) {
            [url appendString:@"&"];
        }
        counter ++;
        
        
    }
    
    NSLog(@"请求URL:%@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:success failure:failure];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
//        [TAOverlay hideOverlay];
        
    });
    
}





+ (void)POST:(NSString *)APIString parameters:(NSMutableArray *)parameters
     success:(void (^)(AFHTTPRequestOperation *, id))success
     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    

    
    
    NSMutableDictionary * request = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in parameters) {
        
        NSString *key = [NSString stringWithFormat:@"%@",[dic objectForKey:API_PARAM_KEY]];
        NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:API_PARAM_VALUE]];
        [request  setObject:value forKey:key];
    }
    
    
    
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",TG_API_DOMAIN,APIString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:URLString parameters:request success:success failure:failure];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
//        [TAOverlay hideOverlay];
        
    });
}




@end
