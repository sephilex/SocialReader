//
//  SEPHI_DownloadCell.m
//  书僮
//
//  Created by lu on 16/5/15.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_DownloadCell.h"
#import "SEPHI_BookInCloud.h"
#import "Bmob.h"
#import "AFNetworking.h"

@interface SEPHI_DownloadCell()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
/** book */
@property (nonatomic, strong) SEPHI_BookInCloud *bookInCloud;
@property (weak, nonatomic) IBOutlet UIView *background;

@end

@implementation SEPHI_DownloadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DLCell";
    SEPHI_DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SEPHI_DownloadCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)download:(UIButton *)sender
{
    [sender setTitle:@"下载中" forState:UIControlStateNormal];
    [sender setUserInteractionEnabled:NO];
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentPath objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt", path, self.bookInCloud.bookName];
    NSLog(@"%@", self.bookInCloud.bookName);
    NSLog(@"%@", self.bookInCloud.file.url);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:self.bookInCloud.file.url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:bn];
        NSFileManager *mgr = [NSFileManager defaultManager];
        [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
        NSLog(@"%@", location);
    }];
    [task resume];
    [sender setTitle:@"已下载" forState:UIControlStateNormal];
}

/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
//- (void)downloadFileWithOption:(NSDictionary *)paramDic
//                 withInferface:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress
//
//{
//    
//    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:requestURL parameters:paramDic error:nil];
//    
//    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
//    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
//    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
//    //
//    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    //
//    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
//    //    [request setHTTPMethod:@"POST"];
//    //
//    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//        
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        
//    }];
//    
//    [operation start];
//    
//}

- (void)setDownloadCell:(SEPHI_BookInCloud *)bookInCloud andTag:(NSInteger)tag
{
    _bookNameLabel.text = bookInCloud.bookName;
    _bookInCloud = bookInCloud;
    if (tag%2==0) {
        _background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"downLight"]];
    }else{
        _background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barImage"]];
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
