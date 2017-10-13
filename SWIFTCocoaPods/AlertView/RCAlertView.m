//
//  RCAlertView.m
//  RentalCar
//
//  Created by 席萍萍 on 16/7/19.
//  Copyright © 2016年 shenzhen yundi technology co.,Ltd. All rights reserved.
//

#import "RCAlertView.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+Additions.h"
#import "UIView+Positioning.h"

static const CGFloat kWidthRatio = 0.7;             // 弹窗占全屏宽度的比例
static const CGFloat kMinViewWidth = 280;           // 弹窗最小宽度
static const CGFloat kHorizontalMargin = 20;        // 水平margin
static const CGFloat kVerticalMargin = 20;          // 垂直margin
static const CGFloat kVerticalPaddingTop = 15;      // 垂直上部分的padding
static const CGFloat kVerticalPaddingBottom = 25;   // 垂直下部分的padding
static const CGFloat kButtonHeight = 40;            // button的高度
static const CGFloat kLineSize = 0.5;               // 分隔线尺寸

static const CGFloat kTitleFontSize = 15;           // title字体
static const CGFloat kMessageFontSize = 13;         // 内容字体
static const CGFloat kCancelButtonFontSize = 15;    // 取消按钮字体
static const CGFloat kConfirmButtonFontSize = 15;   // 确认按钮字体

static RCAlertClickBlock _clickedBlock = nil;       // 点击事件回调
static MBProgressHUD *_alertHud = nil;              // 弹窗


@interface MBProgressHUD ()<RCAlertViewProtocol>

@end

@implementation RCAlertView
#pragma mark - API
+ (id<RCAlertViewProtocol>)alertWithTitle:(NSString *)title
                                  message:(NSString *)message
                      orAttributedMessage:(NSAttributedString *)attributedMessage
                         buttonTitleArray:(NSArray *)buttonTitleArray
                         buttonColorArray:(NSArray *)buttonColorArray
                             clickedBlock:(RCAlertClickBlock)clickedBlock
{
    _clickedBlock = [clickedBlock copy];
    
    CGFloat viewHeight = kVerticalMargin;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width * kWidthRatio;
    viewWidth = viewWidth > kMinViewWidth ? viewWidth : kMinViewWidth;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0)];
    customView.layer.cornerRadius = 10;
    customView.backgroundColor = [UIColor whiteColor];
    
    if (title.length) {
        UIFont *titleFont = [UIFont systemFontOfSize:kTitleFontSize];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = titleFont;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = title;
        [customView addSubview:titleLabel];
        
        CGFloat titleWidth = viewWidth - 2*kHorizontalMargin;
        CGSize titleSize = CGSizeMake(titleWidth, 1000);
        CGFloat titleHeight = [title boundingRectWithSize:titleSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:titleFont}
                                                  context:nil].size.height;
        titleLabel.frame = CGRectMake(kHorizontalMargin,viewHeight, titleWidth, titleHeight);
        viewHeight += titleHeight + kVerticalPaddingTop;
    }
    
    if (message.length || attributedMessage.length) {
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        [customView addSubview:messageLabel];
        
        CGFloat messageWidth = viewWidth - 2*kHorizontalMargin;
        CGSize messageSize = CGSizeMake(messageWidth, 1000);
        
        NSMutableAttributedString *attributedText = nil;
        if (message.length) {
            attributedText = [[NSMutableAttributedString alloc] initWithString:message
                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:kMessageFontSize]}];
            
        }else {
            attributedText = attributedMessage.mutableCopy;
        }
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 5;
        paraStyle.alignment = NSTextAlignmentCenter;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attributedText.length)];
        messageLabel.attributedText = attributedText;
        
        CGFloat messageHeight = [attributedText boundingRectWithSize:messageSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        messageLabel.frame = CGRectMake(kHorizontalMargin, viewHeight, messageWidth, messageHeight);
        viewHeight += messageHeight + kVerticalPaddingBottom;
    }
    
    
    
    NSInteger buttonCount = buttonTitleArray.count;
    // 如果有button数据
    if (buttonCount) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor grayColor];
        view.frame = CGRectMake(0, viewHeight - kLineSize, viewWidth, kLineSize);
        [customView addSubview:view];
        
        CGFloat buttonWidth = viewWidth/buttonCount;
        for (NSInteger i = 0; i < buttonCount; i++) {
            UIColor *buttonColor = buttonColorArray ? buttonColorArray[i] : [UIColor themeColor];
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            button.titleLabel.font = i ? [UIFont boldSystemFontOfSize:kConfirmButtonFontSize] : [UIFont systemFontOfSize:kCancelButtonFontSize];
            button.frame = CGRectMake(0,viewHeight,buttonWidth, kButtonHeight);
            [customView addSubview:button];
            
            button.centerX = i*viewWidth/buttonCount + 0.5*buttonWidth;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 分隔线
            if (i < buttonCount - 1) {
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor grayColor];
                view.frame = CGRectMake(0, 0, kLineSize, kButtonHeight);
                [customView addSubview:view];
            }
        }
        viewHeight += kButtonHeight;
    }
    
    customView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    
    [_alertHud hide:YES];
    _alertHud = (MBProgressHUD *)[self showHUDWithCustomView:customView inView:nil];
    
    return _alertHud;
}


+ (id<RCAlertViewProtocol>)alertWithCustomView:(UIView *)customView title:(NSString *)title
                              buttonTitleArray:(NSArray *)buttonTitleArray
                              buttonColorArray:(NSArray *)buttonColorArray
                                  clickedBlock:(RCAlertClickBlock)clickedBlock
{
    _clickedBlock = [clickedBlock copy];
    
    CGFloat viewHeight = kVerticalMargin;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width * kWidthRatio;
    viewWidth = viewWidth > kMinViewWidth ? viewWidth : kMinViewWidth;
    
    UIView *containerViewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0)];
    containerViewView.layer.cornerRadius = 10;
    containerViewView.backgroundColor = [UIColor whiteColor];
    
    CGFloat customY = 0;
    
    if (title.length) {
        UIFont *titleFont = [UIFont systemFontOfSize:kTitleFontSize];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = titleFont;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = title;
        [containerViewView addSubview:titleLabel];
        
        CGFloat titleWidth = viewWidth - 2*kHorizontalMargin;
        CGSize titleSize = CGSizeMake(titleWidth, 1000);
        CGFloat titleHeight = [title boundingRectWithSize:titleSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:titleFont}
                                                  context:nil].size.height;
        titleLabel.frame = CGRectMake(kHorizontalMargin,viewHeight, titleWidth, titleHeight);
        viewHeight += titleHeight + kVerticalPaddingTop;
        customY = titleLabel.bottom;
    }
    
    
    
    viewHeight += customView.height;
    
    customView.frame = CGRectMake(kHorizontalMargin, customY, viewWidth - 2 * kHorizontalMargin, customView.height);
    [containerViewView addSubview:customView];
    
    NSInteger buttonCount = buttonTitleArray.count;
    // 如果有button数据
    if (buttonCount) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor grayColor];
        view.frame = CGRectMake(0, viewHeight - kLineSize, viewWidth, kLineSize);
        [containerViewView addSubview:view];
        
        CGFloat buttonWidth = viewWidth/buttonCount;
        for (NSInteger i = 0; i < buttonCount; i++) {
            UIColor *buttonColor = buttonColorArray ? buttonColorArray[i] : [UIColor themeColor];
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            button.titleLabel.font = i ? [UIFont boldSystemFontOfSize:kConfirmButtonFontSize] : [UIFont systemFontOfSize:kCancelButtonFontSize];
            button.frame = CGRectMake(0,viewHeight,buttonWidth, kButtonHeight);
            [containerViewView addSubview:button];
            
            button.centerX = i*viewWidth/buttonCount + 0.5*buttonWidth;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 分隔线
            if (i < buttonCount - 1) {
                
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor grayColor];
                view.frame = CGRectMake(0, 0, kLineSize, kButtonHeight);
                view.center =  CGPointMake((i+1)*buttonWidth, button.centerY);
                [containerViewView addSubview:view];
                
            }
        }
        viewHeight += kButtonHeight;
    }
    
    containerViewView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    
    [_alertHud hide:YES];
    _alertHud = (MBProgressHUD *)[self showHUDWithCustomView:containerViewView inView:nil];
    
    return _alertHud;
}


+ (id<RCAlertViewProtocol>)alertWithTitle:(NSString *)title
                                  message:(NSString *)message
                            textAlignment:(NSTextAlignment)alignment
                      orAttributedMessage:(NSAttributedString *)attributedMessage
                         buttonTitleArray:(NSArray *)buttonTitleArray
                         buttonColorArray:(NSArray *)buttonColorArray
                             clickedBlock:(RCAlertClickBlock)clickedBlock
{
    _clickedBlock = [clickedBlock copy];
    
    CGFloat viewHeight = kVerticalMargin;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width * kWidthRatio;
    viewWidth = viewWidth > kMinViewWidth ? viewWidth : kMinViewWidth;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0)];
    customView.layer.cornerRadius = 10;
    customView.backgroundColor = [UIColor whiteColor];
    
    if (title.length) {
        UIFont *titleFont = [UIFont systemFontOfSize:kTitleFontSize];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = titleFont;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = title;
        [customView addSubview:titleLabel];
        
        CGFloat titleWidth = viewWidth - 2*kHorizontalMargin;
        CGSize titleSize = CGSizeMake(titleWidth, 1000);
        CGFloat titleHeight = [title boundingRectWithSize:titleSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:titleFont}
                                                  context:nil].size.height;
        titleLabel.frame = CGRectMake(kHorizontalMargin,viewHeight, titleWidth, titleHeight);
        viewHeight += titleHeight + kVerticalPaddingTop;
    }
    
    if (message.length || attributedMessage.length) {
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        [customView addSubview:messageLabel];
        
        CGFloat messageWidth = viewWidth - 2*kHorizontalMargin;
        CGSize messageSize = CGSizeMake(messageWidth, 1000);
        
        NSMutableAttributedString *attributedText = nil;
        if (message.length) {
            attributedText = [[NSMutableAttributedString alloc] initWithString:message
                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:kMessageFontSize]}];
            
        }else {
            attributedText = attributedMessage.mutableCopy;
        }
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 5;
        paraStyle.alignment = alignment;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attributedText.length)];
        messageLabel.attributedText = attributedText;
        
        CGFloat messageHeight = [attributedText boundingRectWithSize:messageSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        messageLabel.frame = CGRectMake(kHorizontalMargin, viewHeight, messageWidth, messageHeight);
        viewHeight += messageHeight + kVerticalPaddingBottom;
    }
    
    
    
    NSInteger buttonCount = buttonTitleArray.count;
    // 如果有button数据
    if (buttonCount) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor grayColor];
        view.frame = CGRectMake(0, viewHeight - kLineSize, viewWidth, kLineSize);
        [customView addSubview:view];
        
        CGFloat buttonWidth = viewWidth/buttonCount;
        for (NSInteger i = 0; i < buttonCount; i++) {
            UIColor *buttonColor = buttonColorArray ? buttonColorArray[i] : [UIColor themeColor];
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            button.titleLabel.font = i ? [UIFont boldSystemFontOfSize:kConfirmButtonFontSize] : [UIFont systemFontOfSize:kCancelButtonFontSize];
            button.frame = CGRectMake(0,viewHeight,buttonWidth, kButtonHeight);
            [customView addSubview:button];
            
            button.centerX = i*viewWidth/buttonCount + 0.5*buttonWidth;
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 分隔线
            if (i < buttonCount - 1) {
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor grayColor];
                view.frame = CGRectMake(0, 0, kLineSize, kButtonHeight);
                view.center =  CGPointMake((i+1)*buttonWidth, button.centerY);
                [customView addSubview:view];
                
            }
        }
        viewHeight += kButtonHeight;
    }
    
    customView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    
    [_alertHud hide:YES];
    _alertHud = (MBProgressHUD *)[self showHUDWithCustomView:customView inView:nil];
    
    return _alertHud;
}
+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title {
    return [self showWithTitle:title inView:nil];
}

+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title hideAllHudInView:(UIView *)view {
    UIView *theView = view ?: [UIApplication sharedApplication].keyWindow;
    [self hideAll:YES inView:theView];
    
    return [self showWithTitle:title inView:theView];
}

+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title inView:(UIView *)view {
    MBProgressHUD *alertHud = nil;
    
    UIView *superView = view ?: [UIApplication sharedApplication].keyWindow;
    alertHud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    alertHud.mode = MBProgressHUDModeText;
    alertHud.detailsLabelText = title;
    alertHud.detailsLabelFont = [UIFont systemFontOfSize:16];
    
    [alertHud hide:YES afterDelay:1.2];
    
    return alertHud;
}

+ (id<RCAlertViewProtocol>)showLoadingWithTitle:(NSString *)title {
    return [self showLoadingWithTitle:title inView:nil];
}

+ (id<RCAlertViewProtocol>)showLoadingWithTitle:(NSString *)title inView:(UIView *)view {
    
    return [self showCustomLoadingWithTitle:title inView:view];
}

+ (id<RCAlertViewProtocol>)showProgressLoadingWithTitle:(NSString *)title {
    return [self showProgressLoadingWithTitle:title inView:nil];
}

+ (id<RCAlertViewProtocol>)showProgressLoadingWithTitle:(NSString *)title inView:(UIView *)view
{
    
    MBProgressHUD *alertHud = nil;
    UIView *superView = view ?: [UIApplication sharedApplication].keyWindow;
    
    alertHud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    alertHud.mode = MBProgressHUDModeDeterminate;
    alertHud.labelText = title;
    alertHud.progress = 0.05; // 给一个初始值，有更好的体验
    
    return alertHud;
}

+ (id<RCAlertViewProtocol>)showCustomLoadingInView:(UIView *)view
{
    return [self showCustomLoadingWithTitle:nil inView:view];
}

+ (id<RCAlertViewProtocol>)showCustomLoadingWithTitle:(NSString *)title inView:(UIView *)view
{
    
    MBProgressHUD *alertHud = nil;
    UIView *superView = view ?: [UIApplication sharedApplication].keyWindow;
    
    [self hideAll:YES inView:superView];
    
    alertHud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    
    alertHud.mode = MBProgressHUDModeCustomView;
    alertHud.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    alertHud.labelText = title;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < 20; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%zd",i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        [images addObject:image];
    }
    
    imageView.animationImages = images;
    imageView.animationDuration = 1.25;
    [imageView startAnimating];
    
    alertHud.customView = imageView;
    
    alertHud.square = YES;
    return alertHud;
    
}


+ (void)hide:(BOOL)animated inView:(UIView *)view {
    for (MBProgressHUD *hud in view.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            [hud hide:animated];
            
            return;
        }
    }
}

+ (void)hideAll:(BOOL)animated inView:(UIView *)view {
    for (MBProgressHUD *hud in view.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            [hud hide:animated];
        }
    }
}

+ (void)hideInWindow:(BOOL)animated {
    [self hide:animated inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)hideAllInWindow:(BOOL)animated {
    [self hideAll:animated inView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - event response
/**
 *  点击点击事件
 *
 *  @param button 点击的按钮
 */
+ (void)buttonClick:(UIButton *)button {
    if (_clickedBlock) {
        _clickedBlock(button.tag, [button titleForState:UIControlStateNormal]);
    }
    
    _clickedBlock = nil;
    [_alertHud hide:YES];
    _alertHud = nil;
}

#pragma mark - private

/**
 *  显示自定义HUD
 *
 *  @param customView 传入自定义视图
 */
+ (id<RCAlertViewProtocol>)showHUDWithCustomView:(UIView *)customView inView:(UIView *)view {
    
    MBProgressHUD *alertHud = nil;
    UIView *theView = view ?: [UIApplication sharedApplication].keyWindow;
    [theView endEditing:YES];
    alertHud = [MBProgressHUD showHUDAddedTo:theView animated:YES];
    alertHud.mode = MBProgressHUDModeCustomView;
    alertHud.dimBackground = YES;
    alertHud.margin = 0;
    alertHud.customView = customView;
    
    return alertHud;
}


@end
