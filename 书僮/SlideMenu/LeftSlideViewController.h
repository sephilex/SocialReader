//
//  LeftSlideViewController.h
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIView.h"
#import "LeftSortsViewController.h"

//屏幕尺寸相关参数
#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height
#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   0.8  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX 30 //左侧初始偏移量
#define kLeftScale 0.7 //左侧初始缩放比例

#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag


@interface LeftSlideViewController : UIViewController

/** 滑动速度系数 */
@property (nonatomic, assign) CGFloat speedf;

/** 侧滑左侧控制器 */
@property (nonatomic, strong) UIViewController *leftVc;

@property (nonatomic, strong) UIViewController *mainVc;

/** 点击手势控制器，是否允许点击视图恢复位置。默认为YES */
@property (nonatomic, strong) UITapGestureRecognizer *tapToBackGes;

/** 滑动手势控制器 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

/** 判断侧滑窗口是否关闭 */
@property (nonatomic, assign) BOOL isClosed;

/**
 *  初始化
 *
 *  @param leftVc 侧滑菜单控制器
 *  @param mainVc 主界面控制器
 */
- (instancetype)initWithLeftView:(LeftSortsViewController *)leftVc andMainView:(UINavigationController *)mainVc;

- (void)closeLeftView;

- (void)openLeftView;
- (void)setPanEnabled:(BOOL) enabled;

@end
