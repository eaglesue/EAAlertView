//
//  AlertManager.m
//  ECR
//
//  Created by 苏刁 on 16/12/12.
//  Copyright © 2016年 Chengdu Weway Technology. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager () <EAAlertViewDelegate>

@property (nonatomic, strong) NSOperationQueue *alertQueue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;


@end

static AlertManager *_manager = nil;

@implementation AlertManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _alertQueue = [[NSOperationQueue alloc] init];
        _alertQueue.maxConcurrentOperationCount = 1;
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareManager];
}

#pragma mark - Public Method
- (void)showAlert:(EAAlertView *)alert {
    
    alert.delegate = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert showAlert];
        });
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    }];
    [_alertQueue addOperation:operation];
}

//- (void)showMessage:(NSString *)message {
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//        UIViewController *topVC = [self getTopVC];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MessageBox Show:topVC.view Message:message sleep:2];
//        });
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            dispatch_semaphore_signal(_semaphore);
//        });
//        
//        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//    }];
//    [_alertQueue addOperation:operation];
//}

#pragma mark - Private Method

- (UIViewController *)getTopVC
{
    return [self getTopVCFromVC:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)getTopVCFromVC:(UIViewController *)fromVC {
    if ([fromVC isKindOfClass:[UITabBarController class]]) {
        return [self getTopVCFromVC:[(UITabBarController *)fromVC selectedViewController]];
    }
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        return [self getTopVCFromVC:[(UINavigationController *)fromVC topViewController]];
    }
    if ([fromVC isKindOfClass:[UIViewController class]]) {
        if (fromVC.presentedViewController) {
            return [self getTopVCFromVC:fromVC.presentedViewController];
        } else {
            return fromVC;
        }
        
    }
    return fromVC;
}


#pragma mark - Delegate
#pragma mark -- <EAAlertViewDelegate>

- (void)alertDidPresented:(EAAlertView *)alert {
    
}

- (void)alertDidDismiss:(EAAlertView *)alert {
    dispatch_semaphore_signal(_semaphore);
}

@end
