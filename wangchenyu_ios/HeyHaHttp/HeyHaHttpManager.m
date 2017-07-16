//
//  HeyHaHttpManager.m
//  heyha_for_ios
//
//  Created by wangchenyu on 16/11/18.
//  Copyright © 2016年 wangchenyu. All rights reserved.
//

#import "HeyHaHttpManager.h"
#import "UserManger.h"
#import "NSString+CheckString.h"
#import "HeyHaTeacherUrlConst.h"
#import "HeyHaParentUrlConst.h"
@implementation HeyHaHttpManager
#pragma mark  网络请求
+(void)dataRequestWithStrOfUrl:(NSString *)str beAsynchronous:(BOOL)asynchronous GET_OR_POST:(BOOL)beGet postBodyDict:(NSDictionary *)bodyDict postBodyString:(NSString *)bodyString completionBlock:(successBlock)block errorBlock:(errorBlock)errBlock{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:str]];
    
    [request setRequestMethod:beGet?@"GET":@"POST"];
    
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    if ([str isEqualToString:LOGIN_TEACHER_URL] || [str isEqualToString:GET_TEACHER_VERSION] || [str isEqualToString:LOGIN_PARENT_URL] || [str isEqualToString:GET_PARENT_VERSION]) {
        [[[UserManger sharedInstance] modelS] setApp_id:@""];
        [[[UserManger sharedInstance] modelS] setToken_id:@""];
    }
    [request setPostValue:[NSString CheckWithString:[[[UserManger sharedInstance] modelS] app_id]] forKey:@"app_id"];
    [request setPostValue:[NSString CheckWithString:[[[UserManger sharedInstance] modelS] token_id]] forKey:@"token_id"];
    if ([str containsString:@"ios.teacher"]) {
        [request setPostValue:@"heyha_teacher" forKey:@"heyha_state"];
    }else if ([str containsString:@"ios.parent"])
    {
        [request setPostValue:@"heyha_parent" forKey:@"heyha_state"];
    }
    [request setPostValue:version forKey:@"client_version"];
    [request setPostValue:@"ios" forKey:@"smart_state"];
    NSString *param = @"";
    NSMutableArray *bodyArray = [NSMutableArray array];
    if (bodyDict.count > 0) {
        [bodyDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [bodyArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
            
        }];
        for (int i = 0; i < bodyArray.count; i++) {
            if (i > 0) {
                param = [NSString stringWithFormat:@"%@&",param];
            }
            param = [NSString stringWithFormat:@"%@%@",param,bodyArray[i]];
        }
    }
    if ([@"" isEqualToString:[NSString CheckWithString:bodyString]]) {
        param = [NSString stringWithFormat:@"%@&",param];
    }else{
        //实际中请求体放在前面，key－value在后面，所以加上&
        param = [NSString stringWithFormat:@"%@&%@",param,[NSString CheckWithString:bodyString]];
    }
    NSMutableData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setPostBody:data];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setShouldAttemptPersistentConnection:NO];
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        NSError *err=nil;
        NSData *data=weakRequest.responseData;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&err];
        block(dic);
        if (err) {
            NSLog(@"POST ERR With Request Data %@",err);
        }
        if([dic valueForKey:@"session"] && ![[dic valueForKey:@"session"] boolValue])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"session" object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REQUEST_FINISHED" object:nil];
    }];
    [request setFailedBlock:^{
        NSError * ee=[weakRequest error];
        if(ee)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"httperror" object:nil];
        }
        if(errBlock)
        {
            errBlock();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REQUEST_FINISHED" object:nil];
    }];
    if(asynchronous)
        [request startAsynchronous];
    else
        [request startSynchronous];
}



+(void)dataRequestWithStrOfUrlAndImageData:(NSString *)str beAsynchronous:(BOOL)asynchronous GET_OR_POST:(BOOL)beGet postBodyDict:(NSDictionary *)bodyDict postBodyString:(NSString *)bodyString postData:(NSData *)data dataKey:(NSString *)datakey completionBlock:(successBlock)block errorBlock:(errorBlock)errBlock{
    NSURL *url = [NSURL URLWithString:str];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.shouldContinueWhenAppEntersBackground = YES;
    
    if(beGet)
    {
        [request setRequestMethod:@"GET"];
    }
    else
    {
        [request setRequestMethod:@"POST"];
    }
    
    [request setPostValue:@"ios" forKey:@"smart_state"];
    [request setPostValue:@"heyha_teacher" forKey:@"heyha_state"];
    
    [bodyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *object = [NSString stringWithFormat:@"%@",obj];
        [request setPostValue:[object stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }];
    [request addData:data forKey:datakey];
    __weak ASIFormDataRequest *weak = request;
    [request setCompletionBlock:^{
        NSError *err = nil;
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:weak.responseData options:NSJSONReadingMutableContainers error:&err];
        
        block(dic);
        
    }];
    [request setFailedBlock:^{
        NSError *err = nil;
        NSDictionary *failedDic  = [NSJSONSerialization JSONObjectWithData:weak.responseData options:NSJSONReadingMutableContainers error:&err];
    }];
    if(asynchronous)
    {
        [request startAsynchronous];
    }
    else
    {
        [request startSynchronous];
    }
}

#pragma mark  文件下载
+(void)requestWithUrl:(NSString *)url andFileName:(NSString *)fileName andFilePathName:(NSString *)filePathName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock{
    ASIHTTPRequest *request = [ASIHTTPRequest  requestWithURL:[NSURL URLWithString:[NSString CheckWithString:url]]];
    NSString *filePath = [HeyHaFileManager createFileWithUrl:url andFilePathName:filePathName andFileName:fileName];
    request.downloadDestinationPath = filePath;
    [request startAsynchronous];
    [request setFailedBlock:^{
        errBlock();
    }];
    [request setCompletionBlock:^{
        successBlock(filePath);
    }];
}
+(void)requestWithUrl:(NSString *)url andFileName:(NSString *)fileName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock
{
    [self requestWithUrl:url andFileName:fileName andFilePathName:nil completionBlock:successBlock errorBlock:errBlock];
}
+(void)requestWithUrl:(NSString *)url andFilePathName:(NSString *)filePathName completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock
{
    [self requestWithUrl:url andFilePathName:filePathName completionBlock:successBlock errorBlock:errBlock];
}
+(void)requestWithUrl:(NSString *)url completionBlock:(successBlock)successBlock errorBlock:(errorBlock)errBlock{
    
    [self requestWithUrl:url andFileName:nil completionBlock:successBlock errorBlock:errBlock];
}


@end
