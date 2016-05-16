//
//  SEPHI_CommentCell.h
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEPHI_Comment;
@interface SEPHI_CommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCommentCell:(SEPHI_Comment *)comment andTag:(NSInteger)tag;
@end
