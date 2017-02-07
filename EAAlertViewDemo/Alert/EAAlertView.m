//
//  EAAlertView.m
//  PersonalSales
//
//  Created by 苏刁 on 16/10/19.
//  Copyright © 2016年 xxz. All rights reserved.
//

#import "EAAlertView.h"
#import <objc/runtime.h>

#define APP_WIDTH [UIScreen mainScreen].bounds.size.width

@interface EAAlertView () <UIAlertViewDelegate, UIActionSheetDelegate> {
    EAAlertAction *_cancelAction;
    UIViewController *_topVc;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) EAAlertViewStyle  style;
@property (nonatomic, strong) NSMutableArray *actionsArray;
@property (nonatomic, strong) NSMutableArray *textFieldConfigArray;
@property (nonatomic, strong) id alertContanier;


@end

@implementation EAAlertView

+ (instancetype)alertWithTitle:(NSString *)title meesage:(NSString *)message style:(EAAlertViewStyle)style {
    
    EAAlertView *alert = [[EAAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    alert.style = style;
    alert.actionsArray = [NSMutableArray array];
    
//    //给顶层的controller添加一个EAAlertView属性，避免self被自动释放后代理方法无效
//    [alert addProperty:alert];
    return alert;
}

//- (void)addProperty:(id)property {
//    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = [self getTopControllerFromViewController:vc];
//    _topVc = topVC;
//    objc_setAssociatedObject(topVC, _cmd, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)releaseProperty {
//    
//    objc_setAssociatedObject(_topVc, @selector(addProperty:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)addAction:(EAAlertAction *)action {
    action.alertView = self;
    if (action.style == EAAlertActionStyleCancel) {
        _cancelAction = action;
    } else {
     [_actionsArray addObject:action];
    }
}

- (void)addTextField:(ConfigurationBlock)textConfig {
    if (!_textFieldConfigArray) {
        _textFieldConfigArray = [NSMutableArray array];
    }
    [_textFieldConfigArray addObject:textConfig];
}

- (void)showAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:self.style == EAAlertViewStyleAlert ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    if (_accessaryView) {
        CGRect frame = _accessaryView.frame;
        if (_style == EAAlertViewStyleSheet) {
            frame.origin.y = 10;
            frame.size.width = APP_WIDTH - 40;
        } else {
            frame.origin.y = 50;
            frame.origin.x = 5;
            frame.size.width = 250;
        }
        
        _accessaryView.frame = frame;
        CGFloat fontFloat = [UIFont systemFontSize] + 14;
        NSInteger lineCount = _accessaryView.frame.size.height / fontFloat;
        if (_style == EAAlertViewStyleAlert) {
            lineCount++;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            lineCount = lineCount + 2;
        }
        NSString *alertMessage = @"";
        for (NSInteger i = 0; i < lineCount; i++) {
            alertMessage = [alertMessage stringByAppendingString:@"\n"];
        }
        
        alert.message = alertMessage;
        [alert.view addSubview:_accessaryView];
        
    }
    
    for (EAAlertAction *EAaction in _actionsArray) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:EAaction.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EAActionBlock strongActionBlock = EAaction.block;
            if (strongActionBlock) {
                strongActionBlock(EAaction);
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidDismiss:)]) {
                    [self.delegate alertDidDismiss:self];
                }
            });
        }];
        [alert addAction:alertAction];
    }
    
    if (_cancelAction) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_cancelAction.title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            EAActionBlock strongActionBlock = _cancelAction.block;
            if (strongActionBlock) {
                strongActionBlock(_cancelAction);
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidDismiss:)]) {
                    [self.delegate alertDidDismiss:self];
                }
            });
        }];
        [alert addAction:cancelAction];
    }
    
    if (_textFieldConfigArray) {
        for (ConfigurationBlock config in _textFieldConfigArray) {
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                if (config) {
                    config(textField);
                }
            }];
        }
    }
    
    UIViewController *nc = [self getTopControllerFromViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    [nc presentViewController:alert animated:YES completion:^{
        //            [self releaseProperty];
    }];
    _alertContanier = alert;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidPresented:)]) {
        [self.delegate alertDidPresented:self];
    }
}

- (void)alertCancel {
    
    UIAlertController *alert = (UIAlertController *)_alertContanier;
    [alert dismissViewControllerAnimated:YES completion:^{
//        [self releaseProperty];
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidDismiss:)]) {
            [self.delegate alertDidDismiss:self];
        }
    }];
}

- (UIViewController *)getTopControllerFromViewController:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)vc;
        return [self getTopControllerFromViewController:tabVC.selectedViewController];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)vc;
        return [self getTopControllerFromViewController:navi.topViewController];
    }
    
    if (vc.childViewControllers && vc.childViewControllers.count != 0) {
        return [self getTopControllerFromViewController:[vc.childViewControllers lastObject]];
    }

    return vc;
}

#pragma mark - Delegate

@end
