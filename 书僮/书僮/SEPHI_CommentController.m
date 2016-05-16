//
//  SEPHI_CommentController.m
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_CommentController.h"
#import "SEPHI_Comment.h"
#import "SEPHI_CommentCell.h"
#import "Bmob.h"
#import "MJRefresh.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface SEPHI_CommentController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *commentView;
/** 评论模型数组 */
@property (nonatomic, strong) NSMutableArray *commentArray;
/** commentTextview */
@property (nonatomic, strong) UITextView *commentForPost;
/** 发送 */
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation SEPHI_CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _commentView.backgroundColor = [UIColor clearColor];
    _commentView.allowsSelection = NO;
    _commentView.delegate = self;
    _commentView.dataSource = self;
    _commentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadComment)];
    _commentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftbackimage"]];
    
    _commentForPost = [[UITextView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 -40, kScreenWidth - 60, 40)];
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, kScreenHeight - 64 -40, 60, 40)];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    // 马上进入刷新状态
    [_commentView.mj_header beginRefreshing];
    [self.view addSubview:_commentView];
    [self.view addSubview:_commentForPost];
    [self.view addSubview:_sendBtn];

}

- (void) send
{
    [_commentView.mj_header beginRefreshing];
    BmobObject *obj = [BmobObject objectWithClassName:@"comment"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [obj setObject:bUser.username forKey:@"username"];
    [obj setObject:_commentForPost.text forKey:@"comment"];
    [obj setObject:_articleName forKey:@"articleName"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            NSLog(@"%@",obj);
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    [self.commentView reloadData];
    [_commentView.mj_header endRefreshing];
}
- (void) loadComment
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"comment"];
    _commentArray = [NSMutableArray array];
    [bquery whereKey:@"articleName" containedIn:[NSArray arrayWithObject:self.articleName]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            NSLog(@"obj.playerName = %@", [obj objectForKey:@"comment"]);
            SEPHI_Comment *comment = [[SEPHI_Comment alloc] init];
            comment.comment = [obj objectForKey:@"comment"];
            comment.username = [obj objectForKey:@"username"];
            comment.date = [obj createdAt];
            
            [_commentArray addObject:comment];
        }
        [_commentView reloadData];
        [_commentView.mj_header endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEPHI_CommentCell *cell = [SEPHI_CommentCell cellWithTableView:tableView];
    SEPHI_Comment *cm = _commentArray[indexPath.row];
    NSLog(@"cm=======%@", cm);
    [cell setCommentCell:_commentArray[indexPath.row] andTag:indexPath.row];
    return cell;
}

@end
