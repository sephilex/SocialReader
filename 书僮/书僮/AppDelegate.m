//
//  AppDelegate.m
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "BmobSDK/Bmob.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *appKey = @"2389077ca2406a3111f1fbb8d2071408";
    [Bmob registerWithAppKey:appKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //设置通用背景色
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainPageViewController *mainVc = [[MainPageViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVc];
    //侧滑菜单栏控制器
    LeftSortsViewController *leftVc = [[LeftSortsViewController alloc] init];
    //主页控制器
    self.leftSlideVc = [[LeftSlideViewController alloc] initWithLeftView:leftVc andMainView:self.mainNavigationController];
    self.window.rootViewController = self.leftSlideVc;
    //设置导航栏根控制器标题颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.mainNavigationController.navigationBar.titleTextAttributes = dict;
    //设置标题背景色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"barImage"] forBarMetrics:UIBarMetricsDefault];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
