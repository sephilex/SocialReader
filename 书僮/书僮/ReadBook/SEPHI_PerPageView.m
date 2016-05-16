//
//  SEPHI_PerPageView.m
//  书僮
//
//  Created by lu on 16/5/11.
//  Copyright © 2016年 lu. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SEPHI_PerPageView.h"

/**
 *  实际每页显示的内容
 */
@implementation SEPHI_PerPageView

+ (instancetype)PerPageViewWithText:(NSAttributedString *)text andImage:(UIImage *)image andPage:(NSInteger)page andTotalPage:(NSInteger)totalPages
{
    SEPHI_PerPageView *perPageView = [[self alloc] init];
    perPageView.text = text;
    perPageView.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20)];
    perPageView.textView.attributedText = text;
    perPageView.textView.backgroundColor = [UIColor colorWithPatternImage:image];
    perPageView.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-20, kScreenWidth, 20)];
    perPageView.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", page, totalPages];
    perPageView.pageLabel.textAlignment = NSTextAlignmentRight;
    perPageView.pageLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    perPageView.lightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    perPageView.lightnessView.backgroundColor = [UIColor blackColor];
    [perPageView addSubview:perPageView.lightnessView];
    [perPageView addSubview:perPageView.pageLabel];
    [perPageView addSubview:perPageView.textView];
    
    
    return perPageView;
}
@end
