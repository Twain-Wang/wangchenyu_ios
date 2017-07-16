//
//  HeyHaHttpManager.h
//  heyha_for_ios
//
//  Created by wangchenyu on 16/11/18.
//  Copyright © 2016年 wangchenyu. All rights reserved.
//
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HeyHaFileManager.h"
#import <Foundation/Foundation.h>
typedef void (^successBlock)(id dic);
typedef void (^ errorBlock)(void);
@interface HeyHaHttpManager : NSObject
#pragma mark  网络请求  bodyString 最后要加&，不要在前面加&
+ (void)dataRequestWithStrOfUrl:(NSString *)str beAsynchronous:(BOOL)asynchronous GET_OR_POST:(BOOL)beGet postBodyDict:(NSDictionary*)bodyDict postBodyString:(NSString*)bodyString completionBlock:(successBlock)block errorBlock:(errorBlock)errBlock;

+ (void)dataRequestWithStrOfUrlAndImageData:(NSString *)str beAsynchronous:(BOOL)asynchronous GET_OR_POST:(BOOL)beGet postBodyDict:(NSDictionary*)bodyDict postBodyString:(NSString*)bodyString postData:(NSData*)data dataKey:(NSString*)datakey completionBlock:(successBlock)block errorBlock:(errorBlock)errBlock;
#pragma mark download documents 文件下载
/**
 *  网络下载文件
 *
 *  @param url          网络下载链接
 *  @param fileName     文件名称
 *  @param filePathName 文件路径
 *  @param successBlock 成功回调
 *  @param errBlock     失败回调
 */
+(void)requestWithUrl:(NSString *)url andFileName:(NSString *)fileName  andFilePathName:(NSString *)filePathName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock;
/**
 *  网络下载文件
 *
 *  @param url          网络下载链接
 *  @param fileName     文件名称
 *  @param successBlock 成功回调
 *  @param errBlock     失败回调
 */
+(void)requestWithUrl:(NSString *)url andFileName:(NSString *)fileName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock;
/**
 *  网络下载文件
 *
 *  @param url          网络下载链接
 *  @param filePathName 文件路径
 *  @param successBlock 成功回调
 *  @param errBlock     失败回调
 */
+(void)requestWithUrl:(NSString *)url  andFilePathName:(NSString *)filePathName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock;
/**
 *  网络下载文件
 *
 *  @param url          网络下载链接
 *  @param successBlock 成功回调
 *  @param errBlock     失败回调
 */
+(void)requestWithUrl:(NSString *)url completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock;
@end
