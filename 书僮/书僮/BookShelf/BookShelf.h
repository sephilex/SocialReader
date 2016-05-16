//
//  BookShelf.h
//  书僮
//
//  Created by lu on 16/5/6.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookShelf : NSObject
/** 书名 */
@property (nonatomic, strong) NSString *bookName1;
@property (nonatomic, strong) NSString *bookName2;
@property (nonatomic, strong) NSString *bookName3;
/** 封面图片 */
@property (nonatomic, strong) NSString *covName1;
@property (nonatomic, strong) NSString *covName2;
@property (nonatomic, strong) NSString *covName3;

/** 行数 */
@property (nonatomic, assign) NSInteger row;

+ (instancetype)bookShelfWihtStr:(NSString *)str1 andStr2:(NSString *)str2 andStr3:(NSString *)str3 andRow:(NSInteger)row;

@end
