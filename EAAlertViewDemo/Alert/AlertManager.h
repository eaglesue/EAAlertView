//
//  AlertManager.h
//  ECR
//
//  Created by 苏刁 on 16/12/12.
//  Copyright © 2016年 Chengdu Weway Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EAAlertView.h"
//#import "MessageBox.h"

@interface AlertManager : NSObject

+ (instancetype)shareManager;

- (void)showAlert:(EAAlertView *)alert;

//- (void)showMessage:(NSString *)message;

@end
