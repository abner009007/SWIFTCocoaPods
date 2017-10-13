//
//  RCAlertView.h
//  RentalCar
//
//  Created by 席萍萍 on 16/7/19.
//  Copyright © 2016年 shenzhen yundi technology co.,Ltd. All rights reserved.
//  备注：show开头的api是指黑底白字的hud,alert开头的api是弹框。

#import <UIKit/UIKit.h>

static NSString *const kLoading = @"正在加载";
static NSString *const kLoadSuccess = @"加载完成";
static NSString *const kLoadFailed = @"加载出错";
static NSString *const kPullUpLoadMore = @"上拉加载更多";
static NSString *const kAllLoaded = @"已全部加载完";


@protocol RCAlertViewProtocol <NSObject>

@property (assign) NSInteger tag;
@property (assign) CGFloat progress;

- (void)hide:(BOOL)animated;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end


/**
 *  alertView的回调
 *
 
 */
typedef void(^RCAlertClickBlock)(NSInteger buttonIndex, NSString *buttonTitle);


/**
 *  弹窗视图，工具类
 */
@interface RCAlertView : UIView

/**
 *  弹出alertView
 *
 *  @param title             标题
 *  @param message           内容 NSString类型 与 attributedMessage 参数只能传其中一个
 *  @param attributedMessage 内容 NSAttributedString 类型 与message 参数只能传其中一个
 *  @param buttonTitleArray  数组的titleArray
 *  @param buttonColorArray  数组的title颜色array，传的color数量需要和title数量相等，传nil则使用默认的一个主题颜色
 *  @param clickedBlock      点击按钮的回调
 */
+ (id<RCAlertViewProtocol>)alertWithTitle:(NSString *)title
                                  message:(NSString *)message
                      orAttributedMessage:(NSAttributedString *)attributedMessage
                         buttonTitleArray:(NSArray *)buttonTitleArray
                         buttonColorArray:(NSArray *)buttonColorArray
                             clickedBlock:(RCAlertClickBlock)clickedBlock;


+ (id<RCAlertViewProtocol>)alertWithTitle:(NSString *)title
                                  message:(NSString *)message
                            textAlignment:(NSTextAlignment)alignment
                      orAttributedMessage:(NSAttributedString *)attributedMessage
                         buttonTitleArray:(NSArray *)buttonTitleArray
                         buttonColorArray:(NSArray *)buttonColorArray
                             clickedBlock:(RCAlertClickBlock)clickedBlock;


/// 弹出中间部分的自定义视图，标题和按钮还是内部封装好的，自定义视图的frame设置仅高度有效，高度是中间部分视图的高度
+ (id<RCAlertViewProtocol>)alertWithCustomView:(UIView *)customView title:(NSString *)title
                              buttonTitleArray:(NSArray *)buttonTitleArray
                              buttonColorArray:(NSArray *)buttonColorArray
                                  clickedBlock:(RCAlertClickBlock)clickedBlock;

/**
 *  显示一个文字提醒，在1秒后自动消失-  锁屏
 *
 *  @param title 提醒信息
 */
+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title;


/// 显示一个文字提醒，在1秒后自动消失-  锁屏 并隐藏view上原有的所有hud
+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title hideAllHudInView:(UIView *)view;


/**
 *  显示一个文字提醒，在1秒后自动消失-  不锁屏
 *
 *  @param title 信息
 *  @param view  父视图
 *
 *  @return 返回hud
 */
+ (id<RCAlertViewProtocol>)showWithTitle:(NSString *)title inView:(UIView *)view;



/**
 *  显示循环转圈的loadingHUD ----  锁屏
 *
 *  @param title 对应文字信息
 */
+ (id<RCAlertViewProtocol>)showLoadingWithTitle:(NSString *)title;

/**
 *  显示循环转圈loadingHud ---- 不锁屏
 *
 *  @param title 信息
 *  @param view  父视图
 *
 *  @return 对应hud
 */
+ (id<RCAlertViewProtocol>)showLoadingWithTitle:(NSString *)title inView:(UIView *)view;

/**
 *  显示加载进度的loadingHUD ---- 锁屏
 *
 *  @param title 对应文字信息
 */
+ (id<RCAlertViewProtocol>)showProgressLoadingWithTitle:(NSString *)title;

/**
 *  显示加载进度的loadingHud- ---  不锁屏
 *
 *  @param title 文字信息
 *  @param view  父视图
 *
 *  @return 返回hud
 */
+ (id<RCAlertViewProtocol>)showProgressLoadingWithTitle:(NSString *)title inView:(UIView *)view;


/**
 *  显示无文字的loadingHud
 *
 *  @param view 父视图
 *
 *  @return 返回hud
 */
+ (id<RCAlertViewProtocol>)showCustomLoadingInView:(UIView *)view;

/**
 *  隐藏HUD
 *
 *  @param animated 是否需要动画
 */
+ (void)hideInWindow:(BOOL)animated;

/**
 *  隐藏window下的所有hud
 *
 *  @param animated 是否需要动画
 */
+ (void)hideAllInWindow:(BOOL)animated;

/**
 *  隐藏视图下的所有hud
 *
 *  @param animated 是否需要动画
 *  @param view     父视图
 */
+ (void)hideAll:(BOOL)animated inView:(UIView *)view;

@end
