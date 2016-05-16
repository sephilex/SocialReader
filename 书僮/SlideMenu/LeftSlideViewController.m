//
//  LeftSlideViewController.m
//  书僮
//
//  Created by lu on 16/5/5.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "LeftSlideViewController.h"

@interface LeftSlideViewController() <UIGestureRecognizerDelegate>
/** 实时横向位移 */
@property (nonatomic, assign) CGFloat scale;
/** 侧滑菜单宽度 */
@property (nonatomic, assign) CGFloat leftTableViewW;
/** 显示侧滑菜单 */
@property (nonatomic, strong) UITableView *leftTableView;
/** view */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LeftSlideViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (instancetype)initWithLeftView:(LeftSortsViewController *)leftVC
                     andMainView:(UINavigationController *)mainVC
{
    self = [super init];
    if(self){
        self.speedf = vSpeedFloat;
        
        self.leftVc = leftVC;
        self.mainVc = mainVC;
        
//        //滑动手势
//        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
////        [self.mainVc.view addGestureRecognizer:self.pan];
        
//        [self.pan setCancelsTouchesInView:YES];
//        self.pan.delegate = self;
        
        self.leftVc.view.hidden = YES;
        
        [self.view addSubview:self.leftVc.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVc.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVc.view addSubview:view];
        
        //获取左侧tableview
        for (UIView *obj in self.leftVc.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableView = (UITableView *)obj;
            }
        }
        self.leftTableView.backgroundColor = [UIColor clearColor];
        self.leftTableView.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableView.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        
        [self.view addSubview:self.mainVc.view];
        self.isClosed = YES;//初始时侧滑窗关闭
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.leftVc.view.hidden = NO;
}

//滑动手势
//- (void)handlePan:(UIPanGestureRecognizer *)rec{
//    NSLog(@"mc手势");
//    CGPoint point = [rec translationInView:self.view];
//    self.scale = (point.x * self.speedf + self.scale);
//    
//    BOOL needMoveWithTap = YES;
//    
//    if (((self.mainVc.view.x <= 0) && (self.scale <= 0)) || ((self.mainVc.view.x >= (kScreenWidth - kMainPageScale)) && (self.scale >=0))) {
//        self.scale = 0;
//        needMoveWithTap = NO;
//    }
//    
//    //根据视图位置判断是左滑还是右边滑动
//    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
//    {
//        CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
//        if (recCenterX < kScreenWidth * 0.5 - 2) {
//            recCenterX = kScreenWidth * 0.5;
//        }
//        
//        CGFloat recCenterY = rec.view.center.y;
//        
//        rec.view.center = CGPointMake(recCenterX,recCenterY);
//        
//        //scale 1.0~kMainPageScale
//        CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
//        
//        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
//        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
//        
//        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
//        
//        NSLog(@"%f",leftTabCenterX);
//        
//        
//        //leftScale kLeftScale~1.0
//        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
//        
//        self.leftTableView.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
//        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
//        
//        //tempAlpha kLeftAlpha~0
//        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
//        self.contentView.alpha = tempAlpha;
//        
//    }
//    else
//    {
//        //超出范围，
//        if (self.mainVc.view.x < 0)
//        {
//            [self closeLeftView];
//            _scale = 0;
//        }
//        else if (self.mainVc.view.x > (kScreenWidth - kMainPageDistance))
//        {
//            [self openLeftView];
//            _scale = 0;
//        }
//    }
//    
//    //手势结束后修正位置,超过约一半时向多出的一半偏移
//    if (rec.state == UIGestureRecognizerStateEnded) {
//        if (fabs(_scale) > vCouldChangeDeckStateDistance)
//        {
//            if (self.isClosed)
//            {
//                [self openLeftView];
//            }
//            else
//            {
//                [self closeLeftView];
//            }
//        }
//        else
//        {
//            if (self.isClosed)
//            {
//                [self closeLeftView];
//            }
//            else
//            {
//                [self openLeftView];
//            }
//        }
//        _scale = 0;
//    }
//}

#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.isClosed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.isClosed = YES;
        
        self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scale = 0;
        [self removeSingleTap];
    }
    
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVc.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.isClosed = YES;
    
    self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    [UIView beginAnimations:nil context:nil];
    self.mainVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    self.mainVc.view.center = kMainPageCenter;
    self.isClosed = NO;
    
    self.leftTableView.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVc.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.tapToBackGes)
    {
        //单击手势
        self.tapToBackGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.tapToBackGes setNumberOfTapsRequired:1];
        
        [self.mainVc.view addGestureRecognizer:self.tapToBackGes];
        self.tapToBackGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVc.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVc.view removeGestureRecognizer:self.tapToBackGes];
    self.tapToBackGes = nil;
}

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */

//- (void)setPanEnabled: (BOOL) enabled
//{
//    [self.pan setEnabled:enabled];
//}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
        //        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
        //        NSLog(@"响应侧滑");
        return YES;
    }
}



@end
