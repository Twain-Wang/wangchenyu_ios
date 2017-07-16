//
//  NSString+CheckString.h
//  heyha_for_ios
//
//  Created by wangchenyu on 16/11/23.
//  Copyright © 2016年 wangchenyu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (CheckString)

/**
 *  校验string类型数据
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)CheckWithString:(id)string;
/**
 *  判断string类型数据是否为空
 *
 *  @param string
 *
 *  @return YES:为空    NO:不为空
 */
+(Boolean)StringIsNullOrEmpty:(NSString *)string;



/**
 *  手动添加空格符号nbsp;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)addSpaceSymdl:(NSString*)string;
/**
 *  手动删除空格符号nbsp;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)removeSpaceSymdl:(NSString*)string;


/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL)isMobile:(NSString *)mobileNumbel;

/**
 *  身份证验证
 *
 *  @param idCard 传入的身份证号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+(BOOL)checkUserIdCard: (NSString *) idCard;



/**
 *  验证数字长度
 *
 *  @param number 传入的长度
 *  @param number 传入的内容
 *  @return 格式正确返回true  错误 返回fals
 */
+(BOOL)checkLengthWithNumber:(NSString *)number andTitle:(NSString *)title;



/**
 *  去掉前后空格;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)removeSpaceLeftAndRight:(NSString*)string;


/**
 *  去掉年月日;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)removeYearAndMonthAndDay:(NSString*)string;

/**
 *  增加年月日;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)addYearAndMonthAndDay:(NSString*)string;

@end
