//
//  SEPHI_DownloadCell.h
//  书僮
//
//  Created by lu on 16/5/15.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEPHI_BookInCloud;
@interface SEPHI_DownloadCell : UITableViewCell

/** 背景tag */
@property (nonatomic, assign) NSInteger tag;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setDownloadCell:(SEPHI_BookInCloud *)bookInCloud andTag:(NSInteger)tag;
@end
