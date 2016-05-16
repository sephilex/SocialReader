//
//  SEPHI_AllBook.h
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEPHI_AllBook : NSObject

/** 文件路径 */
@property (nonatomic, strong) NSString *bookDirectory;
/** 所有书名 不带后缀*/
@property (nonatomic, strong) NSArray *bookNames;
/** 所有书的地址 带文件名，后缀*/
@property (nonatomic, strong) NSArray *bookDirectories;

+ (instancetype)AllBook;
@end
