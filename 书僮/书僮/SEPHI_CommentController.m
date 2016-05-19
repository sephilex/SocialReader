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

@interface SEPHI_CommentController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *commentView;
/** 评论模型数组 */
@property (nonatomic, strong) NSMutableArray *commentArray;
/** commentTextview */
@property (nonatomic, strong) UITextView *commentForPost;
/** 发送 */
@property (nonatomic, strong) UIButton *sendBtn;
/** height */
@property (nonatomic, assign) double keyHeight;
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
    
    _commentForPost = [[UITextView alloc] initWithFrame:CGRectMake(5, kScreenHeight - 64 -40, kScreenWidth - 60, 35)];
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, kScreenHeight - 64 -40, 60, 40)];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    //定义一个toolBar
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem *button1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone
                                                                 target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray *buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    _commentForPost.delegate = self;
    
    [_commentForPost setInputAccessoryView:topView];

    // 马上进入刷新状态
    [_commentView.mj_header beginRefreshing];
    [self.view addSubview:_commentView];
    [self.view addSubview:_commentForPost];
    [self.view addSubview:_sendBtn];

}

- (void) send
{
    NSString *table = @"comment";
    NSString *col = @"articleName";
    NSString *name = self.articleName;
    if(_bookName){
        table = @"bookComment";
        col = @"bookName";
        name = self.bookName;
    }
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
    [_commentView.mj_header beginRefreshing];
    BmobObject *obj = [BmobObject objectWithClassName:table];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [obj setObject:bUser.username forKey:@"username"];
    [obj setObject:_commentForPost.text forKey:@"comment"];
    [obj setObject:name forKey:col];
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
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录再作评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
        [alert show];
        [self resignKeyboard];
    }
}
- (void) loadComment
{
    NSString *table = @"comment";
    NSString *col = @"articleName";
    NSString *name = self.articleName;
    if(_bookName){
        table = @"bookComment";
        col = @"bookName";
        name = self.bookName;
    }
    NSLog(@"bookName==%@", self.bookName);
    BmobQuery *bquery = [BmobQuery queryWithClassName:table];
    _commentArray = [NSMutableArray array];
    [bquery whereKey:col containedIn:[NSArray arrayWithObject:name]];
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

- (void)viewWillAppear:(BOOL)animated
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    _keyHeight = keyboardRect.size.height;
    
    self.commentForPost.frame = CGRectMake(self.commentForPost.frame.origin.x, self.commentForPost.frame.origin.y - keyboardRect.size.height, self.commentForPost.frame.size.width, self.commentForPost.frame.size.height);
    self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, self.sendBtn.frame.origin.y - keyboardRect.size.height, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//    self.commentForPost.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.commentForPost.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//点击完成文章内容退出键盘
- (void)resignKeyboard
{
    self.commentForPost.frame = CGRectMake(self.commentForPost.frame.origin.x, self.commentForPost.frame.origin.y + _keyHeight, self.commentForPost.frame.size.width, self.commentForPost.frame.size.height);
    self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, self.sendBtn.frame.origin.y + _keyHeight, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
    [_commentForPost resignFirstResponder];
    
}


@end
