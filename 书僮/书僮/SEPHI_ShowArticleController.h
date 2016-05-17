//
//  SEPHI_ShowArticleController.h
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPHI_ShowArticleController : UIViewController
/** 指示显示内容 */
@property (nonatomic, assign) NSInteger tag;
/** 显示某用户的文章 */
@property (nonatomic, strong) NSString *username;
@end
