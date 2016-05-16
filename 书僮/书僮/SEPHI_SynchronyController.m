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
            NSLog(@"booknameindex%ld", [bookNameArray indexOfObject:@"萧十一郎"]);
            if ([bookNameArray indexOfObject:[obj objectForKey:@"bookName"]]>1000) {
                bookInCloud.bookName = [obj objectForKey:@"bookName"];
                bookInCloud.file = [obj objectForKey:@"filetype"];
                [_bookInCloudArray addObject:bookInCloud];
            }
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
