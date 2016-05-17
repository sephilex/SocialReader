//
//  MainPageViewController.m
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "BookShelf.h"
#import "BookShelfCell.h"
#import <MJRefresh.h>
#import "ReadBookViewController.h"
#import "SEPHI_Book.h"
#import "SEPHI_AllBook.h"
#import "SEPHIPageViewController.h"
#import "BmobSDK/Bmob.h"
#import "MBProgressHUD.h"

@interface MainPageViewController()<UITableViewDelegate,UITableViewDataSource,BookShelfCellDelegate>
/** 书架 */
@property (nonatomic, strong) UITableView *bookShelfView;

/** 所有书架层 */
@property (nonatomic, strong) NSArray *bookShelfs;

/** 所有书籍的路径、书名 */
@property (nonatomic, strong) SEPHI_AllBook *allBook;

/** 最后一层不满时书籍的数目 */
@property (nonatomic, assign) NSInteger mod;

@end


@implementation MainPageViewController

- (NSArray *)bookShelfs
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    SEPHI_AllBook *allBook = [SEPHI_AllBook AllBook];
//    NSLog(@"书籍数目%ld", allBook.bookNames.count);
//    NSLog(@"书架层数%ld", _bookShelfs.count);
//    NSLog(@"余数%ld", _mod);

    self.allBook = allBook;
    if (_bookShelfs==nil || ((_bookShelfs.count * 3) -_mod) != allBook.bookNames.count) {

        NSMutableArray *bookShelfArray = [NSMutableArray array];
        for (int i=0; i<allBook.bookNames.count; i=i+3) {

            if ((i+1)==allBook.bookNames.count)
            {
                BookShelf *bookShelf = [BookShelf bookShelfWihtStr:allBook.bookNames[i]
                                                           andStr2:@"none"
                                                           andStr3:@"none"
                                                           andRow:i/3];
                [bookShelfArray addObject:bookShelf];
                _mod = 2;
            }else if((i+2)==allBook.bookNames.count){
                BookShelf *bookShelf = [BookShelf bookShelfWihtStr:allBook.bookNames[i]
                                                           andStr2:allBook.bookNames[i+1]
                                                           andStr3:@"none"
                                                           andRow:i/3];

                [bookShelfArray addObject:bookShelf];
                _mod = 1;
            }else{
                BookShelf *bookShelf = [BookShelf bookShelfWihtStr:allBook.bookNames[i]
                                                           andStr2:allBook.bookNames[i+1]
                                                           andStr3:allBook.bookNames[i+2]
                                                           andRow:i/3];
                [bookShelfArray addObject:bookShelf];
                _mod = 0;
            }
        }
        _bookShelfs = bookShelfArray;
    }
    return _bookShelfs;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *bookDircetory = [documentPath objectAtIndex:0];
    NSArray *bookNameArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:bookDircetory error:nil];

    
    self.title = @"书籍列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *slideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    slideMenuBtn.frame = CGRectMake(0, 0, 17, 14);
    [slideMenuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    //控制左侧菜单关闭与否
    [slideMenuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:slideMenuBtn];
    
    UIButton *refreshMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshMenuBtn.frame = CGRectMake(0, 0, 20, 20);
    [refreshMenuBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    //控制左侧菜单关闭与否
    [refreshMenuBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshMenuBtn];
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.bookShelfView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.allowsSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
        [tableView.mj_header endRefreshing];
    }];
    
    //书架主页背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftbackimage"]];
    
    [self.view addSubview:tableView];
    
}

#pragma -mark 刷新书架
- (void)refresh
{
//    [self viewDidLoad];
    [self.bookShelfView reloadData];
}

#pragma -mark 跳转到阅读界面
-(void)pushToReadBook:(NSInteger)tag
{

//    ReadBookViewController *rc = [[ReadBookViewController alloc] init];
    SEPHIPageViewController *rc = [[SEPHIPageViewController alloc] init];
//    rc.tag = tag;
    rc.bookName = self.allBook.bookNames[tag];
    rc.bookDirectory = self.allBook.bookDirectories[tag];

    [self.navigationController pushViewController:rc animated:YES];
}

#pragma -mark 删除一本书
- (void)removeABook:(NSInteger)tag
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = self.allBook.bookDirectories[tag];
    BOOL isDelete=[fileManager removeItemAtPath:path error:nil];
    NSLog(@"%d", isDelete);
    [self refresh];
}

#pragma  -mark 上传

- (void)upload:(NSInteger)tag
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    NSString *path = self.allBook.bookDirectories[tag];
    NSString *bookname = self.allBook.bookNames[tag];
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"Book"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobFile *file = [[BmobFile alloc] initWithFilePath:path];
    
    [self.view addSubview:hud];
    hud.labelText = @"后台上传中";
    [hud showAnimated:YES whileExecutingBlock:^{
        do {
            
        } while (file.url.length<20);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];

    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"come here");
            [obj setObject:file  forKey:@"filetype"];
            [obj setObject:bookname forKey:@"bookName"];
            [obj setObject:bUser.username forKey:@"username"];
            [obj saveInBackground];
            //打印file文件的url地址
            NSLog(@"file1 url %@",file.url);
        }
    } withProgressBlock:^(CGFloat progress) {
        hud.labelText = [NSString stringWithFormat:@"上传中%.2f%%", progress*100];
    }];
    
    
}

#pragma -mark 加载bookShelfCell数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookShelfs.count > 3 ? self.bookShelfs.count : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162 * ([UIScreen mainScreen].bounds.size.height/568);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row + 1) > self.bookShelfs.count) {
        BookShelfCell *cell = [BookShelfCell cellWithTableView:tableView];
        BookShelf *bookShelf = [BookShelf bookShelfWihtStr:@"none" andStr2:@"none" andStr3:@"none"andRow:indexPath.row];
        cell.bookShelf = bookShelf;
        
        return cell;
    }
    BookShelfCell *cell = [BookShelfCell cellWithTableView:tableView];
    cell.bookShelf = self.bookShelfs[indexPath.row];
    cell.delegate = self;
    return cell;

}

#pragma -mark 点击左上角菜单使用
- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDel.leftSlideVc.isClosed)
    {
        [tempAppDel.leftSlideVc openLeftView];
    }else
    {
        [tempAppDel.leftSlideVc closeLeftView];
    }
}



//- (void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    AppDelegate *tempAppDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDel.leftSlideVc setPanEnabled:NO];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//     AppDelegate *tempAppDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDel.leftSlideVc setPanEnabled:YES];
//    
//}
@end
