//
//  SEPHI_PageController.m
//  书僮
//
//  Created by lu on 16/5/8.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_PageController.h"
#import "SEPHI_PageView.h"

@interface SEPHI_PageController ()

@end

@implementation SEPHI_PageController

+ (instancetype)pageControll:(SEPHI_PerPageView *)pageView
{
    SEPHI_PageController *pageController = [[self alloc] init];
    pageController.pageView = pageView;
    
    return pageController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
