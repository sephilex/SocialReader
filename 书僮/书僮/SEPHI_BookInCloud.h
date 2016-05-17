//
//  SEPHI_BookInCloud.h
//  书僮
//
//  Created by lu on 16/5/15.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bmob.h"
@interface SEPHI_BookInCloud : NSObject

/**  书籍名称*/
@property (nonatomic, strong) NSString *bookName;
/** bmobfile */
@property (nonatomic, strong) BmobFile *file;
/** 本地是否存在 */
@property (nonatomic, assign) BOOL isExist;
/** 本地路劲 */
@property (nonatomic, strong) NSString *bookDirectory;
/** 云端是否存在 */
@property (nonatomic, assign) BOOL isExistInCloud;
/** bookObject */
@property (nonatomic, strong) NSString *objectId;
@end
