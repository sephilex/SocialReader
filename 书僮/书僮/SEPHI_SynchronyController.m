//
//  SEPHI_SynchronyController.m
//  书僮
//
//  Created by lu on 16/5/15.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_SynchronyController.h"
#import "SEPHI_DownloadCell.h"
#import "SEPHI_BookInCloud.h"
#import "MJRefresh.h"
#import "Bmob.h"

@interface SEPHI_SynchronyController ()<UITableViewDelegate,UITableViewDataSource>

/** 下载的view */
@property (nonatomic, strong) UITableView *DLTableView;
/** 查询云端书籍 */
@property (nonatomic, strong) BmobQuery *bquery;
/** 用户 */
@property (nonatomic, strong) BmobUser *bUser;
/** 云端书籍数组 */
@property (nonatomic, strong) NSMutableArray *bookInCloudArray;
/** cell个数 */
@property (nonatomic, assign) NSInteger count;

@end

const NSInteger limit = 10;
@implementation SEPHI_SynchronyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bookInCloudArray = [[NSMutableArray alloc] init];
    _bUser = [BmobUser getCurrentUser];
    _bquery = [BmobQuery queryWithClassName:@"Book"];
    _bquery.limit = limit;
    [_bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
             SEPHI_BookInCloud *bookInCloud = [[SEPHI_BookInCloud alloc] init];
            bookInCloud.bookName = [obj objectForKey:@"bookName"];
            bookInCloud.file = [obj objectForKey:@"filetype"];
            [_bookInCloudArray addObject:bookInCloud];
            NSLog(@"obj.bookName = %@", [obj objectForKey:@"bookName"]);
            NSLog(@"obj.bookName = %@", [obj objectForKey:@"filetype"]);
            //打印objectId,createdAt,updatedAt
            NSLog(@"obj.objectId = %@", [obj objectId]);
            NSLog(@"obj.createdAt = %@", [obj createdAt]);
            NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
        }
        self.count = array.count;
        NSLog(@"数据库元素个数%ld", array.count);
    }];
    
    
    _DLTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _DLTableView.backgroundColor = [UIColor clearColor];
    _DLTableView.allowsSelection = NO;
    _DLTableView.delegate = self;
    _DLTableView.dataSource = self;
    self.DLTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.DLTableView.mj_header beginRefreshing];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftbackimage"]]];
    [self.view addSubview:_DLTableView];
}

- (void)loadNewData
{
    _bookInCloudArray = [[NSMutableArray alloc] init];
    _bUser = [BmobUser getCurrentUser];
    _bquery = [BmobQuery queryWithClassName:@"Book"];
    _bquery.limit = limit;
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    NSArray *bookNameArray = [def objectForKey:@"allBookName"];
    [_bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            SEPHI_BookInCloud *bookInCloud = [[SEPHI_BookInCloud alloc] init];
            bookInCloud.isExist = [bookNameArray containsObject:[obj objectForKey:@"bookName"]];
            bookInCloud.bookName = [obj objectForKey:@"bookName"];
            bookInCloud.file = [obj objectForKey:@"filetype"];
            bookInCloud.objectId = [obj objectId];
            [_bookInCloudArray addObject:bookInCloud];
//            NSLog(@"obj.bookName = %@", [obj objectForKey:@"bookName"]);
//            NSLog(@"obj.bookName = %@", [obj objectForKey:@"filetype"]);
//            //打印objectId,createdAt,updatedAt
//            NSLog(@"obj.objectId = %@", [obj objectId]);
//            NSLog(@"obj.createdAt = %@", [obj createdAt]);
//            NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
        }
        [_DLTableView reloadData];
        NSLog(@"数据库元素个数%ld", array.count);
        [_DLTableView.mj_header endRefreshing];
    }];
   

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEPHI_BookInCloud *tmp = _bookInCloudArray[indexPath.row];
    
    NSLog(@"%@", tmp.file);
    [tmp.file deleteInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"successful!");
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
            [alert show];
        }
    }];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Book"];
    [bquery getObjectInBackgroundWithId:tmp.objectId block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
            NSLog(@"进行错误处理");
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                        [alert show];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                        [alert show];
                    }
                }];
            }
        }
    }];
    [self.bookInCloudArray removeObjectAtIndex:indexPath.row];
    [_DLTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld", self.count);
    return _bookInCloudArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEPHI_DownloadCell *cell = [SEPHI_DownloadCell cellWithTableView:tableView];
    [cell setDownloadCell:_bookInCloudArray[indexPath.row] andTag:indexPath.row];
    return cell;
}


@end
