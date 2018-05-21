//
//  AKToast.m
//  AKToast
//
//  Created by allen on 2017/7/13.
//  Copyright © 2017年 Alijk.com. All rights reserved.
//

#import "FastToast.h"
#import "MBProgressHUD.h"
#import "FasetMaterialDesignSpinner.h"
static NSInteger const kHudFontSize = 14;


@interface FastToast ()
@property (nonatomic, strong) MBProgressHUD *hudView;
@property (nonatomic, strong) FasetMaterialDesignSpinner *spinnerView;
@end


@implementation FastToast
+ (instancetype)shareinstance {
    static FastToast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[FastToast alloc] init];
    });
    return toast;
}

- (void)setCircleColor:(UIColor *)circleColor {
    if (_circleColor != circleColor) {
        _circleColor = circleColor;
    }
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    if (_circleWidth != circleWidth) {
        _circleWidth = circleWidth;
    }
}

+ (void)showToastMsg:(NSString *)msg {
    [self showToastMsg:msg delay:1.8];
}

+ (void)showToastMsg:(NSString *)msg image:(UIImage *)image {
    [self showToastMsg:msg delay:1.8 yOffset:0 hudImage:image];
}

+ (void)showToastSuccessMsg:(NSString *)successMsg {
    UIImage *image = [UIImage imageNamed:[@"FastToast.bundle" stringByAppendingPathComponent:@"hudSuccess"]];
    [self showToastMsg:successMsg delay:1.8 yOffset:0 hudImage:image];
}

+ (void)showToastErrorMsg:(NSString *)errorMsg {
    UIImage *image = [UIImage imageNamed:[@"FastToast.bundle" stringByAppendingPathComponent:@"hudError"]];
    [self showToastMsg:errorMsg delay:1.8 yOffset:0 hudImage:image];
}

+ (void)showToastMsg:(NSString *)msg delay:(NSTimeInterval)delay {
    [self showToastMsg:msg delay:delay yOffset:0];
}

+ (void)showToastMsg:(NSString *)msg
               delay:(NSTimeInterval)delay
             yOffset:(CGFloat)yOffset {
    [self showToastMsg:msg delay:delay
               yOffset:yOffset
              hudImage:nil];
}

+ (void)showToastMsg:(NSString *)msg
               delay:(NSTimeInterval)delay
             yOffset:(CGFloat)yOffset
            hudImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideToast];
        UIWindow *view = [self getCurrentLastView];
        [FastToast shareinstance].hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [FastToast shareinstance].hudView.mode = MBProgressHUDModeCustomView;
        [FastToast shareinstance].hudView.labelFont = [UIFont systemFontOfSize:kHudFontSize];
        if (image) {
            [FastToast shareinstance].hudView.customView = [[UIImageView alloc] initWithImage:image];
        }
        [FastToast shareinstance].hudView.removeFromSuperViewOnHide = YES;
        [FastToast shareinstance].hudView.yOffset = yOffset;
        [FastToast shareinstance].hudView.labelText = msg;
        [FastToast shareinstance].hudView.dimBackground = NO;
        [self performSelector:@selector(hideToast) withObject:self afterDelay:delay];
    });
}

+ (UIWindow *)getCurrentLastView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        return [UIApplication sharedApplication].keyWindow;
    } else {
        return [[UIApplication sharedApplication].windows lastObject];
    }
}
+ (void)showToastLoadingMsg:(NSString *)msg {
    [self showToastLoadingMsg:msg graceTime:0];
}

+ (void)showToastLoadingMsg:(NSString *)msg delay:(NSTimeInterval)delay {
    [self showToastLoadingMsg:msg delay:delay graceTime:0 dimBackground:NO mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg graceTime:(CGFloat)graceTime {
    [self showToastLoadingMsg:msg delay:30 graceTime:graceTime dimBackground:NO mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg graceTime:(CGFloat)graceTime dimBackground:(BOOL)dimBackground {
    [self showToastLoadingMsg:msg delay:30 graceTime:graceTime dimBackground:dimBackground mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg
                      delay:(NSTimeInterval)delay
                  graceTime:(float)graceTime
              dimBackground:(BOOL)dimBackground
                       mode:(MBProgressHUDMode)mode {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideToast];
        UIWindow *view = [self getCurrentLastView];
        [FastToast shareinstance].hudView = [[MBProgressHUD alloc] initWithView:view];
        [FastToast shareinstance].hudView.labelFont = [UIFont systemFontOfSize:kHudFontSize];
        [FastToast shareinstance].hudView.removeFromSuperViewOnHide = YES;
        [FastToast shareinstance].hudView.labelText = msg;
        [FastToast shareinstance].hudView.mode = mode;
        [FastToast shareinstance].hudView.dimBackground = dimBackground;
        [FastToast shareinstance].hudView.minShowTime = 0.3;     //最少执行0.3 秒
        [FastToast shareinstance].hudView.graceTime = graceTime; //设置几秒后开始显示，用户体验更好;
        [self performSelector:@selector(hideToast) withObject:self afterDelay:delay];
        [view addSubview:[FastToast shareinstance].hudView];
        [[FastToast shareinstance].hudView show:YES];

    });
}

+ (void)showToastLoadingWithView:(UIView *)view graceTime:(CGFloat)graceTime {
    [self hideToast];
    if (view == nil) {
        view = [self getCurrentLastView];
    }
    FasetMaterialDesignSpinner *spinnerView = [[FasetMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    [FastToast shareinstance].spinnerView = spinnerView;
    if ([FastToast shareinstance].circleWidth) {
        [FastToast shareinstance].spinnerView.lineWidth = [FastToast shareinstance].circleWidth;
    } else {
        [FastToast shareinstance].spinnerView.lineWidth = 2.0f;
    }

    [FastToast shareinstance].spinnerView.bounds = CGRectMake(0, 0, 40, 40);
    if ([FastToast shareinstance].circleColor) {
        [FastToast shareinstance].spinnerView.tintColor = [FastToast shareinstance].circleColor;
    } else {
        [FastToast shareinstance].spinnerView.tintColor = [UIColor blueColor];
    }

    [FastToast shareinstance].spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [[FastToast shareinstance].spinnerView startAnimating];

    [FastToast shareinstance].hudView = [[MBProgressHUD alloc] initWithView:view];
    [FastToast shareinstance].hudView.mode = MBProgressHUDModeCustomView;
    [FastToast shareinstance].hudView.customView = [FastToast shareinstance].spinnerView;
    [FastToast shareinstance].hudView.color = [UIColor clearColor];
    [FastToast shareinstance].hudView.dimBackground = NO;
    [FastToast shareinstance].hudView.removeFromSuperViewOnHide = YES;
    [FastToast shareinstance].hudView.graceTime = graceTime;
    [FastToast shareinstance].hudView.taskInProgress = YES;
    [self performSelector:@selector(hideToast) withObject:self afterDelay:30];
    [view addSubview:[FastToast shareinstance].hudView];
    [[FastToast shareinstance].hudView show:YES];
}


+ (void)showToastLoadingWithView:(UIView *)view {
    [self showToastLoadingWithView:view graceTime:0];
}

+ (void)hideToast {
    if ([FastToast shareinstance].hudView != nil || ![FastToast shareinstance].hudView.isHidden) {
        [[FastToast shareinstance].hudView hide:YES];
        if ([FastToast shareinstance].spinnerView) {
            [[FastToast shareinstance].spinnerView stopAnimating];
        }
    }
}

@end
