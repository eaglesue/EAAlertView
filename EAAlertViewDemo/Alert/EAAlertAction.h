//
//  EAAlertAction.h
//  PersonalSales
//
//  Created by 苏刁 on 16/10/19.
//  Copyright © 2016年 xxz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EAAlertActionStyleDefault,
    EAAlertActionStyleCancel,
} EAAlertActionStyle;

@class EAAlertAction;
@class EAAlertView;

typedef void(^EAActionBlock)(EAAlertAction *action);

@interface EAAlertAction : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, copy) EAActionBlock block;
@property (nonatomic, weak) EAAlertView *alertView;
@property (nonatomic, assign, readonly) EAAlertActionStyle style;

+ (instancetype)alertActionWithTitle:(NSString *)title style:(EAAlertActionStyle)style action:(EAActionBlock )action;

@end
