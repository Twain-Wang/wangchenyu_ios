//
//  NSString+CheckString.m
//  heyha_for_ios
//
//  Created by wangchenyu on 16/11/23.
//  Copyright © 2016年 wangchenyu. All rights reserved.
//

#import "NSString+CheckString.h"

@implementation NSString (CheckString)

/**
 *  校验string类型数据
 *
 *  @param string
 *
 *  @return
 */
+(NSString *)CheckWithString:(id)string{
    if (string == nil || string == NULL || [string  isEqual: @"null"] || [string  isEqual: @"NULL"] || [string  isEqual: @"nil"]) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    return string;
}
/**
 *  判断string类型数据是否为空
 *
 *  @param string
 *
 *  @return YES:为空    NO:不为空
 */
+(Boolean)StringIsNullOrEmpty:(NSString *)string{
    if (string == nil || string == NULL || [string  isEqual: @"null"] || [string  isEqual: @"NULL"] || [string  isEqual: @"nil"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


/**
 *  手动添加空格符号nbsp;
 *
 *  @param string
 *
 *  @return
 */
+(NSString *)addSpaceSymdl:(NSString *)string{
    NSString *info = @"";
    Boolean headover = false;
    NSInteger j = 0;
    NSArray *arrInfo = [string componentsSeparatedByString:@" "];
    for (int i = 0; i < arrInfo.count; i++) {
        if ([NSString StringIsNullOrEmpty:arrInfo[i]] && !headover) {
            j++;
        }else if (![NSString StringIsNullOrEmpty:arrInfo[i]]){
            headover = true;
        }
    }
    if (j>0) {
        info = [string substringFromIndex:j];
        for (int i = 0; i< j; i++) {
            info = [NSString stringWithFormat:@"&nbsp;%@",info];
        }
    }else{
        info = string;
    }
    return info;
}

/**
 *  手动删除空格符号nbsp;
 *
 *  @param string
 *
 *  @return
 */
+(NSString *)removeSpaceSymdl:(NSString *)string{
    if([string containsString:@"&nbsp;"]){
        return [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }else{
        return string;
    }
}



/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL)isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}


/**
 *  身份证验证
 *
 *  @param idCard 传入的身份证号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+(BOOL)checkUserIdCard: (NSString *) idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}

/**
 *  验证数字长度
 *
 *  @param idCard 传入的长度
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+(BOOL)checkLengthWithNumber:(NSString *)number andTitle:(NSString *)title{
    BOOL flag;
    if (number.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2= [NSString stringWithFormat:@"^(\\d{%@})$",number];
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:title];
}



/**
 *  去掉前后空格;
 *
 *  @param string
 *
 *  @return
 */
+(NSString*)removeSpaceLeftAndRight:(NSString*)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  去掉年月日;
 *
 *  @param string
 *
 *  @return
 */
+(NSString *)removeYearAndMonthAndDay:(NSString *)string{
    string = [string  stringByReplacingOccurrencesOfString:@"年" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"月" withString:@""];
    return [string  stringByReplacingOccurrencesOfString:@"日" withString:@""];
}

/**
 *  增加年月日;
 *
 *  @param string
 *
 *  @return
 */
+(NSString *)addYearAndMonthAndDay:(NSString *)string{
    if (string.length == 8) {
        NSString *year = [string substringToIndex:4];
        NSString *month = [string substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [string substringWithRange:NSMakeRange(6, 2)];
        return  [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    }else{
        return @"日期位数有误";
    }
}
@end
