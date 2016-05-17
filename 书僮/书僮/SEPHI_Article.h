//
//  SEPHI_Article.h
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEPHI_Article : NSObject
/** 作者 */
@property (nonatomic, strong) NSString *username;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 文章内容 */
@property (nonatomic, strong) NSString *content;
/** 日期 */
@property (nonatomic, strong) NSDate *date;
/** 评论 */
@property (nonatomic, strong) NSArray *commentArray;
/** objectId */
@property (nonatomic, strong) NSString *objectId;
@end
