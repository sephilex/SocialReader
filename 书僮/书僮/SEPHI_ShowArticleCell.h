//
//  SEPHI_ShowArticleCell.h
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEPHI_Article;
@protocol SEPHI_ShowArticleCellDelegate<NSObject>

- (void)commentPush:(NSString *)articleName;
- (void)refresh;
- (void)pushToShowOne:(NSString *)author;
@end

@interface SEPHI_ShowArticleCell : UITableViewCell

@property (nonatomic,assign) id<SEPHI_ShowArticleCellDelegate>delegate;
/** isShowDeleteBtn*/
@property (nonatomic, assign) BOOL isShowDeleteBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setArticleCell:(SEPHI_Article *)article andTag:(NSInteger)tag;
@end
