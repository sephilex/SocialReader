//
//  SEPHI_Comment.h
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEPHI_Comment : NSObject

/** 评论人 */
@property (nonatomic, strong) NSString *username;
/** 日期 */
@property (nonatomic, strong) NSDate *date;
/** 内容 */
@property (nonatomic, strong) NSString *comment;
/** 所属文章 */
@property (nonatomic, strong) NSString *title;
@end
