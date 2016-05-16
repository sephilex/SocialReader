//
//  LeftSortsViewController.m
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "SEPHI_LoginViewController.h"
#import "SEPHI_PostArticleViewController.h"
#import "SEPHI_SynchronyController.h"
#import "SEPHI_ShowArticleController.h"
#import "BmobSDK/Bmob.h"


@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (NSArray *)sorts
{
    if (_sorts==nil) {
        _sorts = [[NSArray alloc] init];
        _sorts = @[@"登录",@"书友交流",@"发表文章",@"同步书籍",@"我的收藏",@"我的文章"];
    }
    return _sorts;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"leftbackimage"];
    [self.view addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sorts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.text.font = [UIFont systemFontSize:18.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = self.sorts[indexPath.row];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SEPHI_LoginViewController *loginVc;
    SEPHI_PostArticleViewController *postArticleVc;
    SEPHI_SynchronyController *syncVc;
    SEPHI_ShowArticleController *showArticleVc;
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    [tempAppDel.leftSlideVc closeLeftView];
    switch (indexPath.row) {
        case 0:
            loginVc = [[SEPHI_LoginViewController alloc] init];
            if (bUser) {
                loginVc.offset = self.view.frame.size.width;
            }
            [tempAppDel.mainNavigationController pushViewController:loginVc animated:NO];
            loginVc.title = self.sorts[indexPath.row];
            break;
        case 1:
            showArticleVc = [[SEPHI_ShowArticleController alloc] init];
            showArticleVc.tag = 1;
            [tempAppDel.mainNavigationController pushViewController:showArticleVc animated:NO];
            showArticleVc.title = self.sorts[indexPath.row];
            break;
        case 2:
            if (!bUser) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            }else{
                postArticleVc = [[SEPHI_PostArticleViewController alloc] init];
                [tempAppDel.mainNavigationController pushViewController:postArticleVc animated:NO];
                postArticleVc.title = self.sorts[indexPath.row];
            }
            break;
        case 3:
            syncVc = [[SEPHI_SynchronyController alloc] init];
            [tempAppDel.mainNavigationController pushViewController:syncVc animated:NO];
            break;
        case 4:
            if (bUser) {
                showArticleVc = [[SEPHI_ShowArticleController alloc] init];
                showArticleVc.tag = 2;
                [tempAppDel.mainNavigationController pushViewController:showArticleVc animated:NO];
                showArticleVc.title = self.sorts[indexPath.row];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录再查看您的收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            }
            break;
        case 5:
            if (bUser) {
                showArticleVc = [[SEPHI_ShowArticleController alloc] init];
                showArticleVc.tag = 3;
                [tempAppDel.mainNavigationController pushViewController:showArticleVc animated:NO];
                showArticleVc.title = self.sorts[indexPath.row];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录再查看您的文章" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            }
            break;
        default:
            break;
    }
//    if (indexPath.row==0) {
//        [tempAppDel.mainNavigationController pushViewController:loginVc animated:NO];
//        loginVc.title = self.sorts[indexPath.row];
//    }else if(index){
//        [tempAppDel.mainNavigationController pushViewController:vc animated:NO];
//        vc.title = self.sorts[indexPath.row];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



@end
