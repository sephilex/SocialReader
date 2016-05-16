//
//  SEPHIBook.h
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEPHI_Book : NSObject
/** tag */
@property (nonatomic, assign) NSInteger tag;

/** bookDirectory */
@property (nonatomic, strong) NSString *bookDirectory;

/** bookName */
@property (nonatomic, strong) NSString *bookName;

/** bookDirectory 有文件名，包括后缀*/
@property (nonatomic, strong) NSString *bookDirectoryWithFileName;

/** bookName 有后缀*/
@property (nonatomic, strong) NSString *bookNameWithAppend;

+ (instancetype)bookWith:(NSInteger)tag;
@end
