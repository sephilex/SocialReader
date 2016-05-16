//
//  SEPHI_TextField.m
//  书僮
//
//  Created by lu on 16/5/14.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_TextField.h"
#import "objc/runtime.h"

static NSString * const SEPHI_PlaceholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation SEPHI_TextField

-(void)awakeFromNib{
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        Ivar ivar = *(ivars + i);
//        NSLog(@"%s", ivar_getName(ivar));
//    }
//    [self setValue:[UIColor grayColor] forKeyPath:SEPHI_PlaceholderColorKeyPath];
    self.tintColor = self.textColor;
    [self resignFirstResponder];
}
-(BOOL)becomeFirstResponder
{
    [self setValue:self.textColor forKeyPath:SEPHI_PlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:SEPHI_PlaceholderColorKeyPath];
    return [super resignFirstResponder];
}

//- (void)setHighlighted:(BOOL)highlighted{
//    
//}

@end
