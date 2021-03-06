//
//  E_SettingBottomBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingBottomBar.h"
#import "ILSlider.h"
#import "E_HUDView.h"

#define kBottomBarH 150
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface E_SettingBottomBar()
@property (nonatomic,strong) UIButton *darkBtn;
@property (nonatomic,strong) UIButton *lightBtn;
/** 进度条 */
@property (nonatomic, strong) UISlider *rateSlider;

@end

@implementation E_SettingBottomBar
{
    ILSlider *ilSlider;
    UILabel  *showLbl;
    BOOL isFirstShow;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barImage"]];
        isFirstShow = YES;
        [self configUI];
    }
    return self;
    
}


- (void)configUI{
//
//    UIButton *menuBtn = [UIButton buttonWithType:0];
//    [menuBtn setImage:[UIImage imageNamed:@"reader_cover.png"] forState:0];
//    [menuBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
//    menuBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
//    [self addSubview:menuBtn];
    
//    UIButton *commentBtn = [UIButton buttonWithType:0];
//    [commentBtn setImage:[UIImage imageNamed:@"reader_comments.png"] forState:0];
//    [commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
//    commentBtn.frame = CGRectMake(self.frame.size.width - 70, self.frame.size.height - 54, 60, 44);
//    [self addSubview:commentBtn];
//    
//    
//
//    showLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, self.frame.size.height - kBottomBarH - 70, self.frame.size.width - 140 , 60)];
//    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
//    [showLbl setTextColor:[UIColor whiteColor]];
//    showLbl.font = [UIFont systemFontOfSize:18];
//    showLbl.textAlignment = NSTextAlignmentCenter;
//    showLbl.numberOfLines = 2;
//    showLbl.alpha = 0.7;
//    showLbl.hidden = YES;
//    [self addSubview:showLbl];
    
    self.darkBtn = [UIButton buttonWithType:0];
    _darkBtn.frame = CGRectMake(kScreenWidth/2 - 60, self.frame.size.height - 54, 44, 44);
    [_darkBtn setImage:[UIImage imageNamed:@"dark"] forState:0];
    _darkBtn.backgroundColor = [UIColor clearColor];
    _darkBtn.tag = 1;
    [_darkBtn addTarget:self action:@selector(changeLightness:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_darkBtn];
    
    _lightBtn = [UIButton buttonWithType:0];
    
    [_lightBtn setImage:[UIImage imageNamed:@"light"] forState:0];
    _lightBtn.tag = 2;
    [_lightBtn addTarget:self action:@selector(changeLightness:) forControlEvents:UIControlEventTouchUpInside];
    _lightBtn.frame =  CGRectMake(kScreenWidth/2 + 60 - 44, self.frame.size.height - 54, 44, 44);
    [self addSubview:_lightBtn];
    
    _commentBtn = [UIButton buttonWithType:0];
    
    [_commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:0];
    _commentBtn.tag = 3;
    [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.frame =  CGRectMake(kScreenWidth - 60 , self.frame.size.height - 54, 44, 44);
    [self addSubview:_commentBtn];
    
//    _rateSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40 - 50 , self.frame.size.width - 100, 40)];
//    [_rateSlider addTarget:self action:@selector(changeSliderRatioNum) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_rateSlider];
    
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40 - 50 , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        if (!isFirstShow) {
            showLbl.hidden = NO;
            double percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
            showLbl.text = [NSString stringWithFormat:@"%.1f%@",percent*100,@"%"];
        }
        isFirstShow = NO;
       
       
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        
        showLbl.hidden = YES;
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
//        NSInteger page = (NSInteger)round(percent * _chapterTotalPage);
//        if (page == 0) {
//            page = 1;
//        }

        [_delegate sliderToChapterPage:percent];
    }];

    [self addSubview:ilSlider];
    
    //进度label
    UILabel * processLabel = [[UILabel alloc] init];
    processLabel.frame = CGRectMake(5, self.frame.size.height - 54 - 40 - 50, 40, 40);
    processLabel.backgroundColor = [UIColor clearColor];
    processLabel.text = @"进度";
    processLabel.textColor = [UIColor whiteColor];
    processLabel.font = [UIFont systemFontOfSize:16.0];
    [processLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:processLabel];

   
    //前一章 按钮
//    UIButton *preChapterBtn = [UIButton buttonWithType:0];
//    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 54 - 40 - 50, 40, 40);
//    preChapterBtn.backgroundColor = [UIColor clearColor];
//    [preChapterBtn setTitle:@"上一页" forState:0];
//    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
//    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [self addSubview:preChapterBtn];
    
//    //后一章 按钮
//    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
//    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 54 - 40 - 50, 40, 40);
//    nextChapterBtn.backgroundColor = [UIColor clearColor];
//    [nextChapterBtn setTitle:@"下一页" forState:0];
//    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
//    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [self addSubview:nextChapterBtn];
    
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 54 - 50 , self.frame.size.width - 60, 40)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [self addSubview:themeScroll];
    
    //主题编号
    NSInteger themeID = random()%4 + 1;
    
    for (int i = 1; i <= 4; i ++) {
        
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(0 + 36*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
        
        if (i == 1) {
            [themeButton setBackgroundColor:[UIColor whiteColor]];
            
        }else{
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateSelected];
        }
        
        if (i == themeID) {
            themeButton.selected = YES;
        }
        
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateHighlighted];
        themeButton.tag = 7000+i;
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];

    }
}

- (void)themeButtonPressed:(UIButton *)sender{
    
    [sender setSelected:YES];
    
    for (int i = 1; i <= 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        if (button.tag != sender.tag) {
            [button setSelected:NO];
        }
    }
    
    [_delegate themeButtonAction:self themeIndex:sender.tag-7000];
    //    [E_CommonManager saveCurrentThemeID:sender.tag-7000];
}


- (void)changeLightness:(UIButton *)sender{

    [_delegate lightness:sender.tag];
    
}

- (void)comment{
    
    [_delegate comment];
    
}


#pragma mark - 小


- (void)changeSliderRatioNum{
    
    [_delegate sliderToChapterPage:self.rateSlider.value];

}






- (void)showToolBar{
    

    CGRect newFrame = self.frame;
    newFrame.origin.y -= (kBottomBarH +64);
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
    
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    CGRect newFrame = self.frame;
    newFrame.origin.y += (kBottomBarH + 64);

    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        
        
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
