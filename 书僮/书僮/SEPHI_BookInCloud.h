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
@end
