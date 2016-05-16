//
//  SEPHI_PageView.h
//  书僮
//
//  Created by lu on 16/5/10.
//  Copyright © 2016年 lu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SEPHI_PageView : UIView
/** 书本内容 */
@property (nonatomic, strong) NSString *text;
/** 总页数 */
@property (nonatomic, assign) NSInteger totalPages;
/** range */
@property (nonatomic, assign) NSRange *rangeOfPages;

/** range字典数组 */
@property (nonatomic, strong) NSArray *rangeArray;



+ (instancetype)pageviewWithBookDirectory:(NSString *)bookDirectory andRangesArray:(NSArray *)rangsArray;
- (NSAttributedString *)movePage:(NSInteger)index;
- (NSArray *)rangesToArray:(NSInteger)page;
- (void)arrayToRanges:(NSArray *)rangesArray;
@end
