//
//  EAAlertAction.m
//  PersonalSales
//
//  Created by 苏刁 on 16/10/19.
//  Copyright © 2016年 xxz. All rights reserved.
//

#import "EAAlertAction.h"

@interface EAAlertAction ()


@end

@implementation EAAlertAction

+ (instancetype)alertActionWithTitle:(NSString *)title style:(EAAlertActionStyle)style action:(EAActionBlock )action {
    EAAlertAction *alertAction = [[EAAlertAction alloc] init];
    [alertAction setTitle:title];
    [alertAction setStyle:style];
    alertAction.block = action;
    return alertAction;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setStyle:(EAAlertActionStyle)style {
    _style = style;
}

@end
