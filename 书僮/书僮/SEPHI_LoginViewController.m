//
//  SEPHI_LoginViewController.m
//  书僮
//
//  Created by lu on 16/5/12.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_LoginViewController.h"
#import "MBProgressHUD.h"
#import "BmobSDK/Bmob.h"
#import "SEPHI_TextField.h"

@interface SEPHI_LoginViewController ()

@property (weak, nonatomic) IBOutlet SEPHI_TextField *username;
@property (weak, nonatomic) IBOutlet SEPHI_TextField *password;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *resButton;

@property (weak, nonatomic) IBOutlet SEPHI_TextField *resUsername;
@property (weak, nonatomic) IBOutlet SEPHI_TextField *resPassword;
@property (weak, nonatomic) IBOutlet SEPHI_TextField *resPhone;
@property (weak, nonatomic) IBOutlet SEPHI_TextField *resEmail;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


/** bmob查询 */
@property (nonatomic, strong) Bmob *bmob;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation SEPHI_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    if (bUser) {
        _resButton.hidden = YES;
        _usernameLabel.text = bUser.username;
        self.loginViewLeftMargin.constant = [UIScreen mainScreen].bounds.size.width;
    };
    
}

- (IBAction)res
{
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.resUsername.text];
    [bUser setPassword:self.resPassword.text];
    [bUser setMobilePhoneNumber:self.resPhone.text];
    [bUser setEmail:self.resEmail.text];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
            [alert show];
            [self viewDidLoad];
        } else {
            NSLog(@"%@",error);
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写错误，请认真填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
            [alert show];
        }
    }];
}


- (IBAction)showLoginOrRegister:(UIButton *)button {
    
    if (self.loginViewLeftMargin.constant == 0) {
        self.loginViewLeftMargin.constant = -self.view.frame.size.width;
        button.selected = YES;
    }else{
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
    }

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)logout:(id)sender
{
    [BmobUser logout];
    self.loginViewLeftMargin.constant = 0;
    self.resButton.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)backToMain:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}



- (IBAction)login:(UIButton *)sender
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [BmobUser logout];
//    [BmobUser loginWithUsernameInBackground:self.username.text password:self.password.text];
    hud.labelText = @"正在登录";
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        [BmobUser loginWithUsernameInBackground:self.username.text password:self.password.text block:^(BmobUser *user, NSError *error) {
            if (user) {
                NSLog(@"用户名：%@", user.username);
                self.usernameLabel.text = user.username;
                self.loginViewLeftMargin.constant = self.view.frame.size.width;
                NSLog(@"width%f", self.view.frame.size.width);
                self.resButton.hidden = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }else{
                NSLog(@"error%@", error);
                NSLog(@"来到方if中");
                if (error.code==20002) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络或稍后再尝试登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                    [alert show];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];;
                    [alert show];
                }
            }
            
        }];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//- (void)loginForTure:(NSString *)text
//{
//    NSLog(@"来到方法中");
//    if (text.length==0) {
//        NSLog(@"来到方if中");
//           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//        [alert show];
//    }
//}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
