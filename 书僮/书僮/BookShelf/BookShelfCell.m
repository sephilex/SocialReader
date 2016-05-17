//
//  BookShelfCell.m
//  书僮
//
//  Created by lu on 16/5/6.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "BookShelfCell.h"
#import "BookShelf.h"
#import "ReadBookViewController.h"
#import "SEPHI_AllBook.h"

@interface BookShelfCell()<UIAlertViewDelegate>

/** tag */
@property (nonatomic, assign) NSInteger tagToDo;

//书架层背景
@property (weak, nonatomic) IBOutlet UIView *bookShelfView;
//书架第一本书
@property (weak, nonatomic) IBOutlet UIView *bookView1;
@property (weak, nonatomic) IBOutlet UILabel *bookName1;
@property (weak, nonatomic) IBOutlet UIButton *bookImageBtn1;

//书架第二本书
@property (weak, nonatomic) IBOutlet UIView *bookView2;
@property (weak, nonatomic) IBOutlet UILabel *bookName2;
@property (weak, nonatomic) IBOutlet UIButton *bookImageBtn2;
//书架第三本书
@property (weak, nonatomic) IBOutlet UIView *bookView3;
@property (weak, nonatomic) IBOutlet UILabel *bookName3;
@property (weak, nonatomic) IBOutlet UIButton *bookImageBtn3;

/** tag */
@property (nonatomic, assign) NSInteger tag;
@end

@implementation BookShelfCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"bookShelfCell";
    BookShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BookShelfCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setBookShelf:(BookShelf *)bookShelf
{
//    NSLog(@"%@", bookShelf.bookName3);
    _bookShelf = bookShelf;
    self.bookView1.hidden = NO;
    self.bookView2.hidden = NO;
    self.bookView3.hidden = NO;
    if ([bookShelf.bookName1  isEqual: @"none"]) {
        self.bookView1.hidden = YES;
    }
    if ([bookShelf.bookName2  isEqual: @"none"]){
        self.bookView2.hidden = YES;
    }
    if ([bookShelf.bookName3  isEqual: @"none"]){
        self.bookView3.hidden = YES;
    }
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookShelfCell"]];
    self.bookName1.text = bookShelf.bookName1;
    self.bookName2.text = bookShelf.bookName2;
    self.bookName3.text = bookShelf.bookName3;
    
    [self.bookImageBtn1 setBackgroundImage:[UIImage imageNamed:@"shujifengmian"] forState:UIControlStateNormal];
    [self.bookImageBtn2 setBackgroundImage:[UIImage imageNamed:@"shujifengmian"] forState:UIControlStateNormal];
    [self.bookImageBtn3 setBackgroundImage:[UIImage imageNamed:@"shujifengmian"] forState:UIControlStateNormal];
    self.bookImageBtn1.tag = 3*bookShelf.row;
    self.bookImageBtn2.tag = 3*bookShelf.row + 1;
    self.bookImageBtn3.tag = 3*bookShelf.row + 2;
    
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress1.minimumPressDuration = 0.8; //定义按的时间
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress2.minimumPressDuration = 0.8;
    UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress3.minimumPressDuration = 0.8;
    
    [_bookImageBtn1 addGestureRecognizer:longPress1];
    [_bookImageBtn2 addGestureRecognizer:longPress2];
    [_bookImageBtn3 addGestureRecognizer:longPress3];
  
}


- (IBAction)readBook:(UIButton *)sender {
   
    [self.delegate pushToReadBook:sender.tag];
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        UIButton *btn = (UIButton *)gestureRecognizer.self.view;
        SEPHI_AllBook *allBook = [SEPHI_AllBook AllBook];
        NSString *bookName = allBook.bookNames[btn.tag];
 
        NSString *string = [NSString stringWithFormat:@"删除或上传\"%@\"吗？", bookName];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"上传", nil];
        alert.delegate = self;
        self.tagToDo = btn.tag;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.delegate removeABook:self.tagToDo];
    }else if(buttonIndex==2){
        [self.delegate upload:self.tagToDo];
    }
}

@end
