//
//  E_SettingBottomBar.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  底部设置条
 */
@protocol E_SettingBottomBarDelegate <NSObject>


- (void)lightness:(NSInteger)tag;
- (void)sliderToChapterPage:(float)contentPercent;
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
- (void)comment;

@end


@interface E_SettingBottomBar : UIView


@property (nonatomic,assign) id<E_SettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;
//@property (nonatomic,strong) UIButton *darkBtn;
//@property (nonatomic,strong) UIButton *lightBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentBtn;

- (void)changeSliderRatioNum:(float)percentNum;

- (void)showToolBar;

- (void)hideToolBar;

@end
