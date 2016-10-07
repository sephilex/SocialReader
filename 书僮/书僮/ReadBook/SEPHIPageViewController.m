//
//  SEPHIPageViewController.m
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHIPageViewController.h"
#import "SEPHI_PageController.h"
#import "E_SettingBottomBar.h"
#import "SEPHI_PageView.h"
#import "SEPHI_PerPageView.h"
#import "SEPHI_CommentController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kBottomBarH 150

@interface SEPHIPageViewController ()<UIPageViewControllerDataSource,E_SettingBottomBarDelegate>

/** 底部工具栏*/
@property (nonatomic, strong) E_SettingBottomBar *settingBottomBar;
/** 背景图片 */
@property (nonatomic, strong) UIImage *image;
/** 图片序号 */
@property (nonatomic, assign) NSInteger imageNum;

/** 是否使用了滑动条跳页码 */
@property (nonatomic, assign) BOOL isUseSlider;

/** 滑动页码 */
@property (nonatomic, assign) NSInteger slideTo;
/** sep */
@property (nonatomic, strong) SEPHI_PageController *dataVc;

/** tv */
@property (nonatomic, strong) UITextView *tv;

@end

@implementation SEPHIPageViewController


-(void)viewWillDisappear:(BOOL)animated
{
    NSNumber *cur = [NSNumber numberWithInteger:self.currentPage];
     NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    [def setObject:_rangsArray forKey:[NSString stringWithFormat:@"%@ranges", _bookName]];
    [def setObject:cur forKey:_bookName];
    NSLog(@"%@", _bookName);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化时隐藏navigationBar和状态栏
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    _rangsArray = [def objectForKey:[NSString stringWithFormat:@"%@ranges", _bookName]];
    NSNumber *cur = [def objectForKey:_bookName];
    
    self.currentPage = [cur integerValue];
    self.imageNum = 0;
    self.image = [UIImage imageNamed:@"reader_bg1"];

    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    
    _allPageView = [SEPHI_PageView pageviewWithBookDirectory:self.bookDirectory andRangesArray:_rangsArray];
    
    _rangsArray = _allPageView.rangeArray;
//    NSDictionary *dict;
//    for (dict in _allPageView.rangeArray) {
//        NSLog(@"%@", dict);
//    }
    
    NSDate *date2 = [NSDate date];
    NSTimeInterval timeStamp2= [date2 timeIntervalSince1970];
    NSLog(@"用时：%f", timeStamp2-timeStamp);
    
    self.totalPage = _allPageView.totalPages;
    
    _pageView = [SEPHI_PerPageView PerPageViewWithText:[_allPageView movePage:self.currentPage] andImage:self.image andPage:self.currentPage+1 andTotalPage:self.totalPage];
    //pageViewController配置
    SEPHI_PageController *vc = [[SEPHI_PageController alloc] init];
    vc.pageView = _pageView;
    [vc.view addSubview:vc.pageView];
    
    NSArray *vcArr = [NSArray arrayWithObject:vc];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    [[self.pageViewVc view] setFrame:[[self view] bounds]];
    
    [self.pageViewVc setViewControllers:vcArr
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:YES
                            completion:nil];
    [self addChildViewController:self.pageViewVc];
    self.pageViewVc.dataSource = self;

    //添加视图
    [self.view addSubview:_pageViewVc.view];
    
    //呼出工具栏按钮 透明
    UIButton *funcBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    funcBtn.backgroundColor = [UIColor clearColor];
    [funcBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    funcBtn.center = self.view.center;
    [self.view addSubview:funcBtn];
    
    //底栏
    _settingBottomBar = [[E_SettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
    _settingBottomBar.chapterTotalPage = _allPageView.totalPages;
    _settingBottomBar.delegate = self;
    
    
    [self.view addSubview:_settingBottomBar];
    
}
- (void)lightness:(NSInteger)tag
{
    if (tag==1) {
        if (_pageView.textView.alpha>0.1) {
            _pageView.textView.alpha = _pageView.textView.alpha - 0.1;
            _pageView.pageLabel.alpha = _pageView.pageLabel.alpha - 0.1;
        }
    }else{
        if (_pageView.textView.alpha<1) {
            _pageView.textView.alpha = _pageView.textView.alpha + 0.1;
            _pageView.pageLabel.alpha = _pageView.pageLabel.alpha + 0.1;
        }
    }
}

- (void)comment{
    SEPHI_CommentController *commentVc = [[SEPHI_CommentController alloc] init];
    commentVc.bookName = self.bookName;
    
    [self.navigationController pushViewController:commentVc animated:NO];
}
#pragma -mark 切换背景按钮方法
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme
{
    if (theme != self.imageNum) {
        
        self.imageNum = theme;
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)theme]];
        _pageView.textView.backgroundColor = [UIColor colorWithPatternImage:self.image];
        _pageView.pageLabel.backgroundColor = [UIColor colorWithPatternImage:self.image];
    }

}

#pragma -mark 跳页
- (void)sliderToChapterPage:(float)contentPercent
{
    
    NSInteger page = (NSInteger)(_allPageView.totalPages * contentPercent);
    self.currentPage = page;
    NSLog(@"%ld", page);
    if (page==_allPageView.totalPages) {
        page = _allPageView.totalPages-1;
    }
    _pageView.textView.attributedText = [_allPageView movePage:page];
    _pageView.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPage, self.totalPage];

}

#pragma -mark 工具栏出现与否 按钮方法
- (void)dismissClick
{
    BOOL isClosed = !self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:isClosed withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:isClosed animated:YES];
    if (isClosed==NO) {
        NSLog(@"打开");
        [self.settingBottomBar showToolBar];
    }else{
        NSLog(@"关闭");
        [self.settingBottomBar hideToolBar];
    }

}

#pragma -mark PageviewController数据源方法
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage==0) {
        return nil;
    }
    self.currentPage--;
    _pageView = [SEPHI_PerPageView PerPageViewWithText:[_allPageView movePage:self.currentPage] andImage:self.image andPage:self.currentPage+1 andTotalPage:self.totalPage];
    _dataVc = [SEPHI_PageController pageControll:_pageView];
    [_dataVc.view addSubview:_pageView];
    
    return _dataVc;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentPage==_allPageView.totalPages-1) {
        return nil;
    }
    NSLog(@"%ld", self.currentPage);
    self.currentPage++;
    _pageView = [SEPHI_PerPageView PerPageViewWithText:[_allPageView movePage:self.currentPage] andImage:self.image andPage:self.currentPage+1 andTotalPage:self.totalPage];
    _dataVc = [SEPHI_PageController pageControll:_pageView];
    [_dataVc.view addSubview:_pageView];
    
    return _dataVc;
}

@end
