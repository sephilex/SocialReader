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
#import "SEPHI_ShowArticleController.h"

@interface SEPHI_ShowArticleCell()
@property (weak, nonatomic) IBOutlet UIView *cellBackground;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *usernameBtn;

/** 作者 */
@property (nonatomic, strong) NSString *author;
/** objectId */
@property (nonatomic, strong) NSString *objectId;


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
- (IBAction)usernameShowArticle
{
    [self.delegate pushToShowOne:_author];
}

- (IBAction)delete
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser removeObjectsInArray:@[self.titleLabel.text] forKey:@"articleName"];
    [bUser updateInBackground];
    
    NSLog(@"%@", _objectId);
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"article"];
    [bquery getObjectInBackgroundWithId:_objectId block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
            NSLog(@"进行错误处理");
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self.delegate refresh];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                        [alert show];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                        [alert show];
                    }
                }];
            }
        }
    }];
    
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
    NSString *username = [NSString stringWithFormat:@"作者：%@", article.username];
    _author = article.username;
    [_usernameBtn setTitle:username forState:UIControlStateNormal];
    _contentTextView.text = article.content;
    _titleLabel.text = article.title;
    _objectId = article.objectId;
    _deleteBtn.hidden = _isShowDeleteBtn;
    _contentTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"downLight"]];
    BmobUser *bUser = [BmobUser getCurrentUser];
    NSArray *collection = [bUser objectForKey:@"myFavorites"];
    if ([collection indexOfObject:self.titleLabel.text]<1000) {
        self.collectionBtn.selected = YES;
    }
   
    self.cellBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barImage"]];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
