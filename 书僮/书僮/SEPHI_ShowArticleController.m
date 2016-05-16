//
//  SEPHI_ShowArticleController.m
//  书僮
//
//  Created by lu on 16/5/16.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "SEPHI_ShowArticleController.h"
#import "SEPHI_ShowArticleCell.h"
#import "SEPHI_CommentController.h"
#import "SEPHI_Article.h"
#import "MJRefresh.h"
#import "bmob.h"

@interface SEPHI_ShowArticleController ()<UITableViewDelegate, UITableViewDataSource, SEPHI_ShowArticleCellDelegate>
/** showArtile */
@property (nonatomic, strong) UITableView *showArticleView;
/** 文章模型数组 */
@property (nonatomic, strong) NSMutableArray *articleArray;
@end

@implementation SEPHI_ShowArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showArticleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _showArticleView.backgroundColor = [UIColor clearColor];
    _showArticleView.allowsSelection = NO;
    _showArticleView.delegate = self;
    _showArticleView.dataSource = self;
    _showArticleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadArticle)];
    
    // 马上进入刷新状态
    [_showArticleView.mj_header beginRefreshing];
    
     [self.view addSubview:_showArticleView];
}

-(void)loadArticle
{
    _articleArray = [[NSMutableArray alloc] init];
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"article"];
    bquery.limit = 10;
    if (_tag==1) {
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                //打印playerName
                SEPHI_Article *article = [[SEPHI_Article alloc] init];
                
                article.title = [obj objectForKey:@"title"];
                article.content = [obj objectForKey:@"content"];
                article.username = [obj objectForKey:@"username"];
                article.date = [obj createdAt];
                [_articleArray addObject:article];
                
                //                        NSLog(@"obj.title = %@", article.title);
                //                        NSLog(@"obj.username = %@", [obj objectForKey:@"username"]);
                //            //            //打印objectId,createdAt,updatedAt
                //                        NSLog(@"obj.objectId = %@", [obj objectId]);
                //                        NSLog(@"obj.createdAt = %@", [obj createdAt]);
                //                        NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
            }
            [_showArticleView reloadData];
            NSLog(@"数据库元素个数%ld", array.count);
            [_showArticleView.mj_header endRefreshing];
        }];
    }else if(_tag==2){
        NSArray *myFavoritesArray = [bUser objectForKey:@"myFavorites"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                //打印playerName
                
                SEPHI_Article *article = [[SEPHI_Article alloc] init];
                if ([myFavoritesArray indexOfObject:[obj objectForKey:@"title"]]<1000) {
                    article.title = [obj objectForKey:@"title"];
                    article.content = [obj objectForKey:@"content"];
                    article.username = [obj objectForKey:@"username"];
                    article.date = [obj createdAt];
                    [_articleArray addObject:article];
                }
                
                //                        NSLog(@"obj.title = %@", article.title);
                //                        NSLog(@"obj.username = %@", [obj objectForKey:@"username"]);
                //            //            //打印objectId,createdAt,updatedAt
                //                        NSLog(@"obj.objectId = %@", [obj objectId]);
                //                        NSLog(@"obj.createdAt = %@", [obj createdAt]);
                //                        NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
            }
            [_showArticleView reloadData];
            NSLog(@"数据库元素个数%ld", array.count);
            [_showArticleView.mj_header endRefreshing];
        }];
    }else if(_tag==3){
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                //打印playerName
                
                SEPHI_Article *article = [[SEPHI_Article alloc] init];
                if ([obj objectForKey:@"username"]==bUser.username) {
                    article.title = [obj objectForKey:@"title"];
                    article.content = [obj objectForKey:@"content"];
                    article.username = [obj objectForKey:@"username"];
                    article.date = [obj createdAt];
                    [_articleArray addObject:article];
                }
                
                //                        NSLog(@"obj.title = %@", article.title);
                //                        NSLog(@"obj.username = %@", [obj objectForKey:@"username"]);
                //            //            //打印objectId,createdAt,updatedAt
                //                        NSLog(@"obj.objectId = %@", [obj objectId]);
                //                        NSLog(@"obj.createdAt = %@", [obj createdAt]);
                //                        NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
            }
            [_showArticleView reloadData];
            NSLog(@"数据库元素个数%ld", array.count);
            [_showArticleView.mj_header endRefreshing];
        }];
    }

}
- (void)commentPush:(NSString *)articleName
{
    SEPHI_CommentController *commentVc = [[SEPHI_CommentController alloc] init];
    commentVc.articleName = articleName;
    
    [self.navigationController pushViewController:commentVc animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.articleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 299;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEPHI_ShowArticleCell *cell = [SEPHI_ShowArticleCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell setArticleCell:_articleArray[indexPath.row] andTag:indexPath.row];
    return cell;
}

@end
