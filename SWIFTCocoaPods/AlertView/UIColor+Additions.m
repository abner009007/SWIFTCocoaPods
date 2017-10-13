//  YunDiTrip
//
//  Created by Hgq on 16/3/2.
//  Copyright © 2016年 shenzhen yundi technology co.,Ltd. All rights reserved.
//
#import "UIColor+Additions.h"

typedef unsigned int ADDColorType;

#define ADD_RED_MASK        0xFF0000
#define ADD_GREEN_MASK      0xFF00
#define ADD_BLUE_MASK       0xFF

#define ADD_RED_SHIFT       16
#define ADD_GREEN_SHIFT     8
#define ADD_BLUE_SHIFT      0

#define ADD_COLOR_SIZE      255.0

#define GREEN_COLOR_HEX @"009d85"

#define DEFAULT_COLOR_HEX @"3c3c3c"

@implementation UIColor (Additions)


/**
 *  用色命名方案2.0
 */



+ (UIColor *)themeColor
{
    return [self add_colorWithRGBHexString:@"1e6dd3"];//1e6dd3  168ad6
}
+ (UIColor *)themeTitleColor
{
    return [self add_colorWithRGBHexString:@"333333"];
}
+ (UIColor *)themeGrayTitleColor
{
    return [self add_colorWithRGBHexString:@"999999"];
}

+ (UIColor *)themeRedColor
{
    return [self add_colorWithRGBHexString:@"ff0000"];
}


+ (UIColor *)themeBackgroundColor
{
    return [self add_colorWithRGBHexString:@"ffffff"];
}


/**
 *  基础配色方案
 */
+ (UIColor*)add_colorWithRGBHexString:(NSString*)rgbStrValue
{
    ADDColorType rgbHexValue;
    
    NSScanner* scanner = [NSScanner scannerWithString:rgbStrValue];
    BOOL successful = [scanner scanHexInt:&rgbHexValue];
    
    if (!successful)
        return nil;
    
    return [self add_colorWithRGBHexValue:rgbHexValue];
}

+ (UIColor*)add_colorWithRGBHexValue:(ADDColorType)rgbValue
{
    return [UIColor colorWithRed:((CGFloat)((rgbValue & ADD_RED_MASK) >> ADD_RED_SHIFT))/ADD_COLOR_SIZE
                           green:((CGFloat)((rgbValue & ADD_GREEN_MASK) >> ADD_GREEN_SHIFT))/ADD_COLOR_SIZE
                            blue:((CGFloat)((rgbValue & ADD_BLUE_MASK) >> ADD_BLUE_SHIFT))/ADD_COLOR_SIZE
                           alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString;
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor whiteColor];
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}




+ (UIImage *)createImageWithColor:(UIColor *)color
{
    return [UIColor createImageWithColor:color width:1.0f height:1.0f];
}

+ (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect=CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
