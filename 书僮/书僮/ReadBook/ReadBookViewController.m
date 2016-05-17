//
//  ReadBookViewController.m
//  书僮
//
//  Created by lu on 16/5/7.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "ReadBookViewController.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320.0
#define kHeight(R) (iPhone4?((R)*(kScreenHeight)/480.0):((R)*(kScreenHeight)/568.0))


@interface ReadBookViewController()<UITextViewDelegate>

/** 内容显示 */
@property (nonatomic, strong) UITextView *textView;
/** fontView */
@property (nonatomic, strong) UIButton *fontView;
/** btn */
@property (nonatomic, strong) UIBarButtonItem *button04;
/** toorbar */
@property (nonatomic, strong) UIToolbar *toolBar;
/** tool */
@property (nonatomic, strong) UIToolbar *bottomBar;

/** 页码 */
@property (nonatomic, assign) int currentPage;
/** 页码 */
@property (nonatomic, assign) int allPage;
/** 字体大小 */
@property (nonatomic, assign) int fontSize;


//@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
//@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
@implementation ReadBookViewController

@synthesize str;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
//    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    
//    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
//    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    self.str = [[NSString alloc]initWithContentsOfFile:self.bookDirectory encoding:NSUTF8StringEncoding error:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];

    
    [UIView commitAnimations];
    
    
    // self.view.backgroundColor = [UIColor grayColor];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green.png"]];
    imageView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
    [self.view addSubview:imageView];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_textView];
    
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    NSInteger size = [def integerForKey:@"fontSize"];
    if (size<3) {
        size=15;
        [def setInteger:15 forKey:@"fontSize"];
        [def synchronize];
    }
    
    _fontSize = size;
    _textView.font = [UIFont italicSystemFontOfSize:_fontSize];
    //    textView.inputAccessoryView = imageView;
    _textView.textColor = [UIColor blackColor];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = self.str;
    _textView.editable = NO;
    
    _fontView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight )];
    _fontView.backgroundColor = [UIColor blackColor];
    _fontView.alpha = 0.2;
    [self.view addSubview:_fontView];
 
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, kScreenWidth - 100 )];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.center = self.view.center;
    //计算textView的总页数
    _allPage = _textView.contentSize.height / (kScreenHeight) + 1;
    //设置当前页为1
    _currentPage = 1;
    
    UIButton *forwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, 200, 200 )];
    forwordBtn.backgroundColor = [UIColor clearColor];
    [forwordBtn addTarget:self action:@selector(upPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwordBtn];
    
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 200, kScreenHeight - 200, 200, 200)];
    nextBtn.backgroundColor = [UIColor clearColor];
    [nextBtn addTarget:self action:@selector(downPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    //自定义工具栏
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _toolBar.tintColor = [UIColor grayColor];
    [self.view addSubview:_toolBar];
    
    //为工具栏设置按钮
    UIBarButtonItem * button01 = [[UIBarButtonItem alloc] initWithTitle:@"我的书架" style:UIBarButtonItemStylePlain target:self action:@selector(onClick)];
    UIBarButtonItem * button02 = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:@selector(upPage)];
    button02.tag = 200;
    UIBarButtonItem * button03 = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(downPage)];
    button03.tag = 300;
    _button04 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d/%d",_currentPage,_allPage] style:UIBarButtonItemStylePlain target:self action:@selector(hello)];
    _button04.tag = 110;
    //将工具栏按钮添加到一个数组里面
    NSArray * array = [[NSArray alloc] initWithObjects:button01,button02,button03,_button04, nil];
    //给工具栏添加按钮
    [_toolBar setItems:array animated:YES];
    
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [_textView addGestureRecognizer:pan];
   
    
    
    //自定义工具栏
    _bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
    _bottomBar.tintColor = [UIColor grayColor];
    [self.view addSubview:_bottomBar];
    
    UIBarButtonItem * button11 = [[UIBarButtonItem alloc] initWithTitle:@"添加书签" style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    UIBarButtonItem * button12 = [[UIBarButtonItem alloc] initWithTitle:@"读取书签" style:UIBarButtonItemStylePlain target:self action:@selector(readClick)];
    UIBarButtonItem * button13 = [[UIBarButtonItem alloc] initWithTitle:@"暗" style:UIBarButtonItemStylePlain target:self action:@selector(anheiClick)];
    UIBarButtonItem * button14  = [[UIBarButtonItem alloc] initWithTitle:@"亮" style:UIBarButtonItemStylePlain target:self action:@selector(liangClick)];
    UIBarButtonItem * button15  = [[UIBarButtonItem alloc] initWithTitle:@"大" style:UIBarButtonItemStylePlain target:self action:@selector(bigClick)];
    UIBarButtonItem * button16  = [[UIBarButtonItem alloc] initWithTitle:@"小" style:UIBarButtonItemStylePlain target:self action:@selector(smallClick)];
    //将工具栏按钮添加到一个数组里面
    NSArray * arrayBottom = [[NSArray alloc] initWithObjects:button11,button12,button13,button14,button15,button16, nil];
    //给工具栏添加按钮
    [_bottomBar setItems:arrayBottom animated:YES];
  
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self downPage];
 
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self upPage];

    }
}
-(void)dismissClick{
    _toolBar.hidden = !_toolBar.hidden;
    _bottomBar.hidden = !_bottomBar.hidden;
    [[UIApplication sharedApplication] setStatusBarHidden:_bottomBar.hidden withAnimation:UIStatusBarAnimationNone];
    
    
}
-(void)bigClick{
    _fontSize = _fontSize +1;
    _textView.font = [UIFont italicSystemFontOfSize:_fontSize];
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    [def setInteger:_fontSize forKey:@"fontSize"];
    [def synchronize];
    
}
-(void)smallClick{
    _fontSize = _fontSize -1;
    if (_fontSize <5) {
        _fontSize = 5;
    }
    _textView.font = [UIFont italicSystemFontOfSize:_fontSize];
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    [def setInteger:_fontSize forKey:@"fontSize"];
    [def synchronize];
}

-(void)addClick{
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    [def setInteger:_currentPage forKey:[NSString stringWithFormat:@"page%zd",self.index]];
    [def synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息提示" message:@"书签添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

-(void)readClick{
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    NSInteger page = [def integerForKey:[NSString stringWithFormat:@"page%zd",self.index]];
    
    //设置当前页为1
    _currentPage = page-1;
    [self downPage];
    
}
-(void)anheiClick{
    _fontView.alpha = _fontView.alpha >= 0.8 ? 0.8 : (_fontView.alpha + 0.1);
    
}
-(void)liangClick{
    _fontView.alpha = _fontView.alpha <= 0 ? 0 : (_fontView.alpha - 0.1);
    
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint  point = [pan translationInView:_textView];
    if (point.x < -5 && point.x > -10) {
        [pan setTranslation:CGPointMake(0, 0) inView:_textView];
        [self upPage];
        return;
    }else if (point.x > 5 && point.x < 10) {
        [self downPage];
        [pan setTranslation:CGPointMake(0, 0) inView:_textView];
        return;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:_textView];

    return;
}


//点击上一页时响应的事件
-(void)upPage{
    if (_currentPage == 1) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是第一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    _currentPage = _currentPage - 1;

    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [_textView setContentOffset:CGPointMake(0, (_currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    
    [UIView commitAnimations];
    
    [_button04 setTitle:[NSString stringWithFormat:@"%d/%d",_currentPage,_allPage]];
    return;
}
//点击下一页时响应的事件
-(void)downPage{
    if (_currentPage == _allPage) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"这已是最后一页" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    _currentPage = _currentPage + 1;
    
    
    [_button04 setTitle:[NSString stringWithFormat:@"%d/%d",_currentPage ,_allPage]];
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [_textView setContentOffset:CGPointMake(0, (_currentPage - 1) * 430) animated:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
    
    return;
}

-(void)hello{
    return;
}


////此视图将要出现时隐藏导航栏和最上面的横条
//-(void)viewWillAppear:(BOOL)animated{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.35];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//    //隐藏导航栏上面的横条
//
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//
//    //隐藏导航栏
//    //self.navigationController.navigationBar.hidden = YES;
//    [UIView commitAnimations];
//    self.view.backgroundColor = [UIColor grayColor];
//}

//点击我的书架时回到主页
- (void)onClick{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end

