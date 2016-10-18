//
//  ViewController.m
//  PopAlertViewTool
//
//  Created by langyue on 16/10/18.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "ViewController.h"
#import "TipAlertMsgTool.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)alertBtnAction:(UIButton *)sender {


    switch (sender.tag) {
        case 200:
        {//信息展示在通知栏位置

            [TipAlertMsgTool showNotification_Title:@"手机号已经注册" controller:self];

        }
            break;

        case 201:
        {//信息展示在导航栏下的位置


            [TipAlertMsgTool showTip_Msg:@"和可以" inVc:self];

        }
            break;

        case 202:
        {//在当前页面展示

            [TipAlertMsgTool showMsgToCurrentView_Title:@"呵呵哒" vc:self];

        }
            break;

        default:
            break;
    }




}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
