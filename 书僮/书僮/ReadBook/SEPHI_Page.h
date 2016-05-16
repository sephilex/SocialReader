//
//  SEPHI_Page.h
//  书僮
//
//  Created by lu on 16/5/10.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEPHI_Page : NSObject

/** 书本内容 */
@property (nonatomic, strong) NSString *text;
/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;
/** 总页数 */
@property (nonatomic, assign) NSInteger totalPages;
@end
