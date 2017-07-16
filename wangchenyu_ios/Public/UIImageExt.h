//
//  UIImageExt.h
//  teacher
//
//  Created by 张雨 on 15/4/13.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import<UIKit/UIKit.h>
#import "UIColor+zy.h"
@interface UIImage(ColorImage)
+(UIImage*)getColorImageWithHexString:(NSString *)string;
+(UIImage*)getColorImageWithColor:(UIColor *)color;
+ (UIImage *)ZYImageNamed:(NSString*)name;
-(UIImage*)scaleToSize:(CGSize)size;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+(NSData*)makeImageData:(UIImage*)image withByteNum:(NSInteger)byteNum withQuality:(double)quality;
+(UIImage*)makeImageSize:(UIImage*)image withSize:(CGSize)size;
//根据图片宽度等比例获取图片高度
+(int)getImageHeight:(UIImage*)image   withImageWidth:(int)width;
@end
