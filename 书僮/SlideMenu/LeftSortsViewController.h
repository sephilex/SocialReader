//
//  LeftSortsViewController.h
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSortsViewController : UIViewController

/** 侧滑菜单内容显示 */
@property (nonatomic, strong) UITableView *tableView;
/** 侧滑内容数组 */
@property (nonatomic, strong) NSArray *sorts;

@end
