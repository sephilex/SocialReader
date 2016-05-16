//
//  SEPHI_CommentCell.m
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_CommentCell.h"
#import "SEPHI_Comment.h"

@interface SEPHI_CommentCell()

@property (weak, nonatomic) IBOutlet UIView *cellBackground;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end


@implementation SEPHI_CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    SEPHI_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SEPHI_CommentCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCommentCell:(SEPHI_Comment *)comment andTag:(NSInteger)tag
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString * dateToString = [dateFormatter stringFromDate:comment.date];
    _dateLabel.text = dateToString;
    
    _usernameLabel.text = comment.username;
    _dateLabel.text = dateToString;
    _commentTextView.text = comment.comment;
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
