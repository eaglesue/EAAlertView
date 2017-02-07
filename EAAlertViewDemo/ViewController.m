//
//  ViewController.m
//  EAAlertViewDemo
//
//  Created by 苏刁 on 17/2/7.
//  Copyright © 2017年 eaglesue. All rights reserved.
//

#import "ViewController.h"
#import "AlertManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    EAAlertView *alert = [EAAlertView alertWithTitle:@"提 示" meesage:@"这TMD都是啥" style:EAAlertViewStyleAlert];
    EAAlertAction *cancel = [EAAlertAction alertActionWithTitle:@"取 消" style:EAAlertActionStyleCancel action:nil];
    [alert addAction:cancel];
    
    EAAlertAction *confirm = [EAAlertAction alertActionWithTitle:@"确 定" style:EAAlertActionStyleDefault action:^(EAAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [[AlertManager shareManager] showAlert:alert];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
