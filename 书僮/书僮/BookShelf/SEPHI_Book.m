//
//  SEPHIBook.m
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_Book.h"

@interface SEPHI_Book()


@end


@implementation SEPHI_Book

+ (instancetype)bookWith:(NSInteger)tag
{
    SEPHI_Book *book = [[self alloc]init];
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    book.bookDirectory = [documentPath objectAtIndex:0];
    NSArray *bookNameArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:book.bookDirectory error:nil];
    book.bookName = [bookNameArray[tag] stringByDeletingPathExtension];
    book.bookNameWithAppend = bookNameArray[tag];
    book.bookDirectoryWithFileName = [NSString stringWithFormat:@"%@/%@", book.bookDirectory,bookNameArray[tag]];
    return book;
}
@end
