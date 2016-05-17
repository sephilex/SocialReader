//
//  SEPHI_AllBook.m
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_AllBook.h"

@implementation SEPHI_AllBook

+ (instancetype)AllBook
{
    SEPHI_AllBook *allBook = [[self alloc]init];
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    allBook.bookDirectory = [documentPath objectAtIndex:0];
    //带后缀的书籍名称
    NSArray *bookNames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:allBook.bookDirectory error:nil];
    
    NSMutableArray *bn = [NSMutableArray array];
    for (NSString *str in bookNames) {
        if ([str hasSuffix:@".txt"]) {
            NSString *bnStr = [str stringByDeletingPathExtension];
            [bn addObject:bnStr];
        }
    }
  
    NSMutableArray *bd = [NSMutableArray array];
    for (NSString *str in bookNames) {
         if ([str hasSuffix:@".txt"]) {
        NSString *bdr = [NSString stringWithFormat:@"%@/%@", allBook.bookDirectory,str];
        [bd addObject:bdr];
         }
    }
    allBook.bookNames = bn;
    allBook.bookDirectories = bd;
    
    NSUserDefaults *def= [NSUserDefaults standardUserDefaults];
    [def setObject:allBook.bookNames forKey:@"allBookName"];
    
    return allBook;
}

- (NSString *)directoryForBookname:(NSString *)bookname
{
    NSString *dir;
    for (NSString *tmp in _bookDirectories) {
        if ([tmp rangeOfString:bookname].location==NSNotFound)
        {
            dir = tmp;
            break;
        }
    }
    return dir;
}
@end
