//
//  SEPHI_PageView.m
//  书僮
//
//  Created by lu on 16/5/10.
//  Copyright © 2016年 lu. All rights reserved.
//

#define FONT_SIZE_MAX 14
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height-20)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SEPHI_PageView.h"

@interface SEPHI_PageView()



@end


@implementation SEPHI_PageView

+ (instancetype)pageviewWithBookDirectory:(NSString *)bookDirectory andRangesArray:(NSArray *)rangsArray
{
    //初始化 pageview
    SEPHI_PageView *pageview = [[self alloc] init];
    //装入文本内容
    pageview.text = [[NSString alloc] initWithContentsOfFile:bookDirectory encoding:NSUTF8StringEncoding error:nil];
    //按字体大小排版
    NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:pageview.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE_MAX]                                                                                                                                 }];
    if (!rangsArray) {
        NSLog(@"进入if");
        int referTotalPages;
        int referCharatersPerPage;
        pageview.totalPages = 0;
        
        
        //设置不限制行数
        //    pageview.textView.numberOfLines = 0;
        
        //计算出整个文本的尺寸
        
        CGRect totalTextSize = [textString boundingRectWithSize:CGSizeMake(kScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        // 如果一页就能显示完，直接显示所有文本串即可。
        
        //    if (totalTextSize.size.height < kScreenHeight)
        //    {
        // 计算理想状态下的页面数量和每页所显示的字符数量，只是拿来作为参考值用而已！
        //总字符长度
        NSInteger textLength = pageview.text.length;
        //参考总页数
        referTotalPages = ((int)totalTextSize.size.height/(int)kScreenHeight) + 1;
        //参考每页字符数
        referCharatersPerPage = (int)textLength/referTotalPages;
        
        // 申请最终保存页面NSRange信息的数组缓冲区
        int maxPages = referTotalPages;
        pageview.rangeOfPages = (NSRange *)malloc(referTotalPages*sizeof(NSRange));
        memset(pageview.rangeOfPages, 0x0, referTotalPages*sizeof(NSRange));
        
        // 页面索引
        int page = 0;
        NSRange range;
        range.length = referCharatersPerPage;
        

        for (NSUInteger location = 0; location < textLength; )
        {
            range.length = referCharatersPerPage;
            // 先计算临界点（尺寸刚刚超过UILabel尺寸时的文本串）
            range.location = location;
            
            // reach end of text ?
            NSString *pageText1;
            
            //最后一页设置
            if (range.location + range.length >= textLength)
            {
                range.length = textLength - range.location;
            }
            
            int i = 0;
            // 然后一个个缩短字符串的长度，当缩短后的字符串尺寸小于textView的尺寸时即为满足
            while (range.length > 0 )
            {
                i++;
                pageText1 = [pageview.text substringWithRange:range];
                NSAttributedString *pageText =  [[NSAttributedString alloc] initWithString:pageText1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE_MAX]                                                                                                                                 }];
                CGRect pageTextSize = [pageText boundingRectWithSize:CGSizeMake(kScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
                if (pageTextSize.size.height <= kScreenHeight) {
                    range.length = [pageText length];
                    break;
                }
                else {
                    range.length -= 50;
                }
            }
      
            NSLog(@"第%d页数", page);
            // 得到一个页面的显示范围
            if (page >= maxPages)
            {
                maxPages += 10;
                pageview.rangeOfPages = (NSRange *)realloc(pageview.rangeOfPages, maxPages*sizeof(NSRange));
            }
            pageview.rangeOfPages[page++] = range;
            
            // 更新游标
            location += range.length;
        }
        pageview.totalPages = page;
        pageview.rangeArray = [pageview rangesToArray:page-1];
        NSLog(@"%ld", pageview.rangeArray.count);
        // 获取最终页面数量
    }else{
    // 获取最终页面数量
        NSLog(@"进入else");
        NSLog(@"%ld", rangsArray.count);
        pageview.rangeArray = rangsArray;
        pageview.totalPages = rangsArray.count+1;
        [pageview arrayToRanges:rangsArray];
    }
    
    return pageview;
}

//- (void)movePage:(NSInteger)index
//{
//    self.textView.text = [self.text substringWithRange:self.rangeOfPages[index]];
//}


- (NSAttributedString *)movePage:(NSInteger)index
{
    NSLog(@"文本长度%ld", self.text.length);
    NSLog(@"页数%ld", index);
    NSLog(@"loc%ld len%ld", self.rangeOfPages[index].location, self.rangeOfPages[index].length);
    NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:[self.text substringWithRange:self.rangeOfPages[index]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE_MAX]                                                                                                                                 }];
    return textString;
}

- (void)arrayToRanges:(NSArray *)rangesArray
{
    NSInteger totalPages = rangesArray.count;
    self.rangeOfPages = (NSRange *)malloc(totalPages*sizeof(NSRange));
    memset(self.rangeOfPages, 0x0, totalPages*sizeof(NSRange));
    int i = 0;
    for (NSDictionary *dict in rangesArray) {
        NSRange range;
        NSString *loc = dict[@"location"];
        NSString *len = dict[@"length"];
        range = NSMakeRange([loc integerValue], [len integerValue]);
        self.rangeOfPages[i++] = range;
    }
}
- (NSArray *)rangesToArray:(NSInteger)page
{
    int i=0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while (i<=page) {
        NSString *location = [NSString stringWithFormat: @"%ld",self.rangeOfPages[i].location];
        NSString *length = [NSString stringWithFormat: @"%ld",self.rangeOfPages[i].length];
        NSDictionary *dict = @{@"location":location,@"length":length};
        [arr addObject:dict];
        i++;
    }
    return arr;
}
@end

