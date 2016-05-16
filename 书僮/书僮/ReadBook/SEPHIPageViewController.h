//
//  SEPHIPageViewController.h
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEPHI_PageView;
@class SEPHI_PerPageView;

@interface SEPHIPageViewController : UIViewController

/** 文本全内容 */

/** pagecontroller */
@property (nonatomic, strong) UIPageViewController *pageViewVc;
/** url */
@property (nonatomic, strong) NSString *bookDirectory;
/** 书名 */
@property (nonatomic, strong) NSString *bookName;
/** pageView */
@property (nonatomic, strong) SEPHI_PageView *allPageView;
@property (nonatomic, strong) SEPHI_PerPageView *pageView;
/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;
/** 总页数 */
@property (nonatomic, assign) NSInteger totalPage;
/** ranges数组 */
@property (nonatomic, strong) NSArray *rangsArray;
//@property(nonatomic,strong) NSLayoutManager *textLayout;
//
//@property(nonatomic,strong) UITextView *textView;

//@property(nonatomic,strong) NSString *aText;


@end
