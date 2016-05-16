//
//  BookShelfCell.h
//  书僮
//
//  Created by lu on 16/5/6.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookShelfCellDelegate <NSObject>
-(void)pushToReadBook:(NSInteger)tag;
-(void)removeABook:(NSInteger)tag;
-(void)upload:(NSInteger)tag;
@end

@class BookShelf;

@interface BookShelfCell : UITableViewCell

/** 代理 */
@property (nonatomic, strong) id<BookShelfCellDelegate>delegate;

/** 书架属性 */
@property (nonatomic, strong) BookShelf *bookShelf;
//
//@property (weak, nonatomic) IBOutlet UIView *bookShelfView;
////书架第一本书
//@property (weak, nonatomic) IBOutlet UILabel *bookName1;
//@property (weak, nonatomic) IBOutlet UIImageView *imageForBook1;
////书架第二本书
//@property (weak, nonatomic) IBOutlet UILabel *bookName2;
//@property (weak, nonatomic) IBOutlet UIImageView *imageForBook2;
////书架第三本书
//@property (weak, nonatomic) IBOutlet UILabel *bookName3;
//@property (weak, nonatomic) IBOutlet UIImageView *imageForBook3;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
