//
//  TipAlertMsgTool.h
//  ZJPopAlertViewDemo
//
//  Created by langyue on 16/10/17.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define NOTIFICATION_VIEW_HEIGHT 64


@interface TipAlertMsgTool : NSObject
{
    NSString *myTitle;//title
    UIView *myReferenceView;

    UIDynamicAnimator *animator;
    UIGravityBehavior *gravity;
    UICollisionBehavior *collision;
    UISnapBehavior *snap;


    int collisionCount;
}


@property(nonatomic,retain)UIView* theView;



@property(nonatomic,retain)UIView* view_textMove;



@property(nonatomic,retain)UIView* tipsView;
@property(nonatomic,retain)UIView* view_tipsMove;


/**
 *提示信息界面布局
 */
-(void) initWithTipsSubviews;
-(void) applyDynamics;



/**
 *展示提示信息
 *title 提示文字
 *controller 当前控制器
 */
+(void) showNotification_Title:(NSString *)title controller:(UIViewController *)controller;



+(void)showMsgToCurrentView_Title:(NSString*)msgStr vc:(UIViewController*)vc;



+(void)showTip_Msg:(NSString*)msgStr inVc:(UIViewController*)vc;




@end
