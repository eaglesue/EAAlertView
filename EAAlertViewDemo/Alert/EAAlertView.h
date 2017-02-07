//
//  EAAlertView.h
//  PersonalSales
//
//  Created by 苏刁 on 16/10/19.
//  Copyright © 2016年 xxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAAlertAction.h"
#import <UIKit/UIKit.h>

@class EAAlertView;

@protocol EAAlertViewDelegate <NSObject>

@optional

- (void)alertDidPresented:(EAAlertView *)alert;
- (void)alertDidDismiss:(EAAlertView *)alert ;

@end

typedef enum : NSUInteger {
    EAAlertViewStyleAlert,
    EAAlertViewStyleSheet,
} EAAlertViewStyle;

typedef void(^ConfigurationBlock)(UITextField *field);

@interface EAAlertView : NSObject

@property (nonatomic, strong) UIView *accessaryView;

+ (instancetype)alertWithTitle:(NSString *)title meesage:(NSString *)message style:(EAAlertViewStyle)style;

- (void)addTextField:(ConfigurationBlock)textConfig;

- (void)addAction:(EAAlertAction *)action;

- (void)showAlert;

- (void)alertCancel;

@property (nonatomic, weak) id<EAAlertViewDelegate> delegate;
@end
