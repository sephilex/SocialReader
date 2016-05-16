//
//  BookShelf.m
//  书僮
//
//  Created by lu on 16/5/6.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "BookShelf.h"

@implementation BookShelf
+ (instancetype)bookShelfWihtStr:(NSString *)str1 andStr2:(NSString *)str2 andStr3:(NSString *)str3 andRow:(NSInteger)row
{
    BookShelf *bookShelf = [[self alloc] init];
    bookShelf.bookName1 = str1;
    bookShelf.bookName2 = str2;
    bookShelf.bookName3 = str3;
    bookShelf.row = row;
    bookShelf.covName1 = @"shujifengmian";
    bookShelf.covName2 = @"shujifengmian";
    bookShelf.covName3 = @"shujifengmian";
    
    return bookShelf;
}
@end
