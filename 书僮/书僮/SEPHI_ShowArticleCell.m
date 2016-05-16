//
//  SEPHI_ShowArticleCell.m
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_ShowArticleCell.h"
#import "SEPHI_Article.h"
#import "bmob.h"

@interface SEPHI_ShowArticleCell()
@property (weak, nonatomic) IBOutlet UIView *cellBackground;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SEPHI_ShowArticleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"showArticle";
    SEPHI_ShowArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SEPHI_ShowArticleCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
- (IBAction)collection:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (sender.selected) {
        NSLog(@"%@", self.titleLabel.text);
        [bUser addObjectsFromArray:@[self.titleLabel.text] forKey:@"myFavorites"];
        [bUser updateInBackground];
    }else{
        [bUser removeObjectsInArray:@[self.titleLabel.text] forKey:@"myFavorites"];
        [bUser updateInBackground];
    }

}

- (IBAction)comment
{
    [self.delegate commentPush:self.titleLabel.text];
}


- (void)setArticleCell:(SEPHI_Article *)article andTag:(NSInteger)tag
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString * dateToString = [dateFormatter stringFromDate:article.date];
    _dateLabel.text = dateToString;
    _usernameLabel.text = [NSString stringWithFormat:@"作者：%@", article.username];
    _contentTextView.text = article.content;
    _titleLabel.text = article.title;
    BmobUser *bUser = [BmobUser getCurrentUser];
    NSArray *collection = [bUser objectForKey:@"myFavorites"];
    if ([collection indexOfObject:self.titleLabel.text]<1000) {
        self.collectionBtn.selected = YES;
    }
    if (tag%2==0) {
        self.cellBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"downLight"]];
    }else{
        self.cellBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barImage"]];

    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
