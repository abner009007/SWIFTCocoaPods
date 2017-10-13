//
//  YunDiTrip
//
//  Created by Hgq on 16/3/2.
//  Copyright © 2016年 shenzhen yundi technology co.,Ltd. All rights reserved.
//  app内所有颜色来源

#import <UIKit/UIKit.h>

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface UIColor (Additions)

+ (UIColor *)add_colorWithRGBHexString:(NSString*)rgbHexString;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;

/**
 *  用色命名规范2.0
 */

/// 主色调 蓝色 #168ad6
+ (UIColor *)themeColor;

/// 红色主色调 #ff0000
+ (UIColor *)themeRedColor;


/// 黑色   黑色标题文字  #333333
+ (UIColor *)themeTitleColor;

/// 灰色   副标题文字  #979797
+ (UIColor *)themeGrayTitleColor;


@end
