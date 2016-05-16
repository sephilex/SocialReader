//
//  SEPHI_PageController.h
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEPHI_PerPageView;

@interface SEPHI_PageController : UIViewController
/** 每一页内容 */
@property (nonatomic, strong) SEPHI_PerPageView *pageView;

+ (instancetype)pageControll:(SEPHI_PerPageView *)pageView;

@end
