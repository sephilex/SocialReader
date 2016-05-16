//
//  SEPHI_VerticalButton.m
//  书僮
//
//  Created by lu on 16/5/12.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_VerticalButton.h"

@implementation SEPHI_VerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.width);
    
    // 调整文字
    self.titleLabel.frame = CGRectMake(0, self.imageView.frame.size.height, self.frame.size.width,self.frame.size.height-self.imageView.frame.size.height);
    
}

@end
