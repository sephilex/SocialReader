//
//  AppDelegate.h
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 左滑控制器 */
@property (nonatomic, strong) LeftSlideViewController *leftSlideVc;
/** 主导航控制器 */
@property (nonatomic, strong) UINavigationController *mainNavigationController;

@end

