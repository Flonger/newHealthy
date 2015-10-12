//
//  BaseHTTPManager.h
//  MyHealthy
//
//  Created by 薛飞龙 on 15/10/12.
//  Copyright © 2015年 Flonger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define TG_API_DOMAIN   @"http://www.tngou.net/api/"


//请求参数键值对
#define API_PARAM_KEY   @"API_PARAM_KEY"
#define API_PARAM_VALUE @"API_PARAM_VALUE"

@interface BaseHTTPManager : NSObject


/**
 *  GET请求
 */
+ (void)GET:(NSString *)APIString parameters:(NSMutableArray *)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  POST请求
 */
+ (void)POST:(NSString *)APIString parameters:(NSMutableArray *)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
