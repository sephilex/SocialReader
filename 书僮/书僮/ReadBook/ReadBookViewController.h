//
//  ReadBookViewController.h
//  书僮
//
//  Created by lu on 16/5/7.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadBookViewController : UIViewController
/** 内容 */
/** 书的序号 */
@property (nonatomic, assign) NSInteger tag;
/** url */
@property (nonatomic, strong) NSString *bookDirectory;
@property (nonatomic, strong) NSString *str;
/** index */
@property (nonatomic, assign) NSInteger index;


@end
