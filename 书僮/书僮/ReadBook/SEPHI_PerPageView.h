//
//  SEPHI_PerPageView.h
//  书僮
//
//  Created by lu on 16/5/11.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPHI_PerPageView : UIView

/** 已排版的文字 */
@property (nonatomic, strong) NSAttributedString *text;
/** textView */
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *pageLabel;
/** 亮度view */
@property (nonatomic, strong) UIView *lightnessView;
+ (instancetype)PerPageViewWithText:(NSAttributedString *)text andImage:(UIImage *)image andPage:(NSInteger)page andTotalPage:(NSInteger)totalPages;
@end
