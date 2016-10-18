//
//  TipAlertMsgTool.m
//  ZJPopAlertViewDemo
//
//  Created by langyue on 16/10/17.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import "TipAlertMsgTool.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



@implementation TipAlertMsgTool


+(instancetype)shareInstance{
    static TipAlertMsgTool * share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        share = [[TipAlertMsgTool alloc] init];

    });
    return share;
}


+(TipAlertMsgTool*) getView_Title:(NSString *)title referenceView:(UIView *)referenceView
{
    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];
    tool.theView = [[UIView alloc] init];
    tool->myTitle = title;
    tool->myReferenceView = referenceView;
    [tool initWithTipsSubviews];

    return tool;
}

-(void) applyDynamics
{
    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];
    tool->animator = [[UIDynamicAnimator alloc] initWithReferenceView:tool->myReferenceView];
    tool->gravity = [[UIGravityBehavior alloc] initWithItems:@[tool.theView]];
    tool->collision = [[UICollisionBehavior alloc] initWithItems:@[tool.theView]];
    [tool->collision addBoundaryWithIdentifier:@"AlertTipsBoundary" fromPoint:CGPointMake(0, tool.theView.bounds.size.height) toPoint:CGPointMake(tool->myReferenceView.bounds.size.width, tool.theView.bounds.size.height)];
    [(tool->animator) addBehavior:(tool->gravity)];
    [tool->animator addBehavior:tool->collision];
    [tool performSelector:@selector(hideNotification) withObject:nil afterDelay:2.0f];
}

#pragma mark --- 隐藏展示的提示框
-(void) hideNotification
{
    // remove the original gravity behavior

    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];


    [tool->animator removeBehavior:tool->gravity];
    tool->gravity = [[UIGravityBehavior alloc] initWithItems:@[tool->_theView]];
    [tool->gravity setGravityDirection:CGVectorMake(0, -1)];
    [tool->animator addBehavior:tool->gravity];
}

#pragma mark --- 创建提示框信息界面视图
-(void) initWithTipsSubviews
{

    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];


    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    tool.theView.frame = CGRectMake(0, (-1) * NOTIFICATION_VIEW_HEIGHT, screenBounds.size.width, NOTIFICATION_VIEW_HEIGHT);
    tool.theView.backgroundColor = [UIColor blueColor];
    // create the labels
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenBounds.size.width, NOTIFICATION_VIEW_HEIGHT)];
    titleLabel.text = myTitle;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    titleLabel.textColor = [UIColor whiteColor];
    [tool.theView addSubview:titleLabel];
}


#pragma mark
+(void) showNotification_Title:(NSString *)title controller:(UIViewController *)controller
{
    controller = controller.navigationController ? controller.navigationController : controller;
    TipAlertMsgTool * toolView = [TipAlertMsgTool getView_Title:title referenceView:controller.view];
    [controller.view addSubview:toolView.theView];
    [toolView applyDynamics];
}
















#pragma mark ---=====----- 动态移动图
+(void)showMsgToCurrentView_Title:(NSString*)msgStr vc:(UIViewController*)vc{


    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];
    
    tool.view_textMove = [[UIView alloc] initWithFrame:CGRectMake(0, -40, vc.view.frame.size.width, 40)];
    [vc.view addSubview:tool.view_textMove];
    tool.view_textMove.backgroundColor = [UIColor colorWithRed:167.0/255.0 green:245.0/255.0 blue:170.0/255.0 alpha:1.0];

    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tool.view_textMove.frame.size.width-20, 20)];
    [tool.view_textMove addSubview:label_title];
    label_title.text = @"提示信息";


    [TipAlertMsgTool showMessage:msgStr];
    [tool poptipsCurrentView:vc];

}





-(void) poptipsCurrentView:(UIViewController*)vc
{

    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];
    [UIView animateWithDuration:1.0 animations:^{

        tool.view_textMove.frame = CGRectMake(0, 64, vc.view.frame.size.width, 40);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            tool.view_textMove.frame = CGRectMake(0, -40, vc.view.frame.size.width, 40);
        } completion:^(BOOL finished) {

        }];
    }];
    
}


+ (void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];

    UILabel *label = [[UILabel alloc] init];


    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(290, 9000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;

    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((kScreenWidth - LabelSize.width - 20)/2, kScreenHeight - 300, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:3.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW maxH:(CGFloat)maxH
{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize=CGSizeMake(maxW, maxH);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}






//==================||
//==================||
//==================||

+(void)showTip_Msg:(NSString*)msgStr inVc:(UIViewController*)vc{

    TipAlertMsgTool * tool = [TipAlertMsgTool shareInstance];

    tool.tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, vc.view.frame.size.width, 40)];

    //view
    tool.view_tipsMove = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tool.tipsView.frame.size.width, tool.tipsView.frame.size.height)];
    [tool.tipsView addSubview:tool.view_tipsMove];
    tool.view_tipsMove.backgroundColor = [UIColor colorWithRed:167.0/255.0 green:245.0/255.0 blue:170.0/255.0 alpha:1.0];

    //title
    UILabel *label_tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tool.tipsView.frame.size.width-20, tool.view_tipsMove.frame.size.height-20)];
    [tool.view_tipsMove addSubview:label_tips];
    label_tips.text = msgStr;
    label_tips.font = [UIFont systemFontOfSize:15];
    label_tips.textColor = [UIColor blackColor];
    label_tips.textAlignment = NSTextAlignmentLeft;
    label_tips.numberOfLines = 0;
    [label_tips sizeToFit];




    [vc.view addSubview:tool.tipsView];

    [UIView animateWithDuration:1.0 animations:^{

        tool.tipsView.frame = CGRectMake(0, 64, vc.view.frame.size.width, tool.tipsView.frame.size.height);

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionLayoutSubviews animations:^{

            tool.tipsView.frame = CGRectMake(0, -tool.tipsView.frame.size.height, vc.view.frame.size.width, tool.tipsView.frame.size.height);

        } completion:^(BOOL finished) {
            
        }];
        
        
    }];


    
}



@end
