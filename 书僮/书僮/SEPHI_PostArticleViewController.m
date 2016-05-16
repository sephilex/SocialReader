//
//  SEPHI_PostArticleViewController.m
//  书僮
//
//  Created by lu on 16/5/15.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_PostArticleViewController.h"
#import "BmobSDK/Bmob.h"

@interface SEPHI_PostArticleViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *articleForPost;
@property (weak, nonatomic) IBOutlet UITextField *titleForPost;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation SEPHI_PostArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = post;
    
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
    
    self.articleForPost.delegate = self;
    
    [_articleForPost setInputAccessoryView:topView];
}

- (void)post
{
    BmobObject *article = [BmobObject objectWithClassName:@"article"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        [article setObject:self.titleForPost.text forKey:@"title"];
        [article setObject:self.articleForPost.text forKey:@"content"];
        [article setObject:bUser.username forKey:@"username"];
        [article saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //创建对象成功，打印对象值
                NSLog(@"%@",article);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"发表成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            } else if (error){
                //发生错误后的动作
                NSLog(@"%@",error);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"发表失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            } else {
                NSLog(@"Unknow error");
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"发表失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                [alert show];
            }
        }];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
        [alert show];
    }
   
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (_articleForPost.text.length == 0) {
        _placeholder.text = @"请输入文章内容";
    }else{
        _placeholder.text = @"";
    }
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
    
    self.articleForPost.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.articleForPost.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//点击完成文章内容退出键盘
- (void)resignKeyboard
{
    
    [_articleForPost resignFirstResponder];
    
}
@end
