//
//  CLTopicViewController.m
//  百思不得姐
//
//  Created by 杨博兴 on 16/9/29.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import "CLTopicViewController.h"
#import "CLHTTPSessionManager.h"
#import "NSObject+Property.h"
#import "CLTopic.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "CLRefreshHeader.h"
#import "CLRefreshFooter.h"
#import "CLTopicCell.h"
#import "CLCommentViewController.h"

@interface CLTopicViewController ()

@property(nonatomic,strong)NSMutableArray<CLTopic *> *topicArr;

@property(nonatomic,strong)NSString *maxtime;

@property(nonatomic,strong)CLHTTPSessionManager *manager;

@end

@implementation CLTopicViewController

static NSString *const CLTopicCellID = @"topic";

#pragma mark - 仅仅是为了消除编译器发出的警告 : type方法没有实现
-(CLTopicType)type
{
    return 0;
}

-(CLHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [CLHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTable];
    [self setupRefresh];
    
}

-(void)setUpTable
{
    self.tableView.backgroundColor = CLCommonColor(206);
    // 取消cell中间的间隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64+35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CLTopicCell class]) bundle:nil] forCellReuseIdentifier:CLTopicCellID];
    
}

- (void)setupRefresh
{
    //    UIRefreshControl *control = [[UIRefreshControl Topicoc] init];
    //    [control addTarget:self action:@selector(loadNewTopics:) forControlEvents:UIControlEventValueChanged];
    //    [self.tableView addSubview:control];
    
    self.tableView.mj_header = [CLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [CLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

//-(void)loadNewTopics:(UIRefreshControl *)control
-(void)loadNewTopics
{
    // 数组里面的task全部取消
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"list";
    parameter[@"c"] = @"data";
    parameter[@"type"] = @(self.type);
    // block中最好使用弱引用，防止内部强引用控件，使其该销毁的时候不销毁
    __weak typeof(self) weakSelf = self;
    [self.manager GET:CLCommonURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [responseObject writeToFile:@"/Users/yangboxing/Desktop/topic.plist" atomicTopicy:YES];
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        weakSelf.topicArr = [CLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 查找带有最热评论的信息
        //        [responseObject writeToFile:@"/Users/yangboxing/Desktop/new.plist" atomicTopicy:YES];
        //        for (int i = 0; i < self.topicArr.count; i ++) {
        //            if (self.topicArr[i].top_cmt.count) {
        //                CLLog(@"%d",i);
        //            }
        //        }
        
        
        [weakSelf.tableView reloadData];
        CLLog(@"请求成功");
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        //        [control endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CLLog(@"请求失败 -- %@",error);
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        //        [control endRefreshing];
    }];
}

-(void)loadMoreTopics
{
    // 数组里面的task全部取消
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"list";
    parameter[@"c"] = @"data";
    parameter[@"maxtime"] = self.maxtime;
    parameter[@"type"] = @(self.type);
    // block中最好使用弱引用，防止内部强引用控件，使其该销毁的时候不销毁
    __weak typeof(self) weakSelf = self;
    [self.manager GET:CLCommonURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray<CLTopic *> *moreTopics = [CLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 查找带有最热评论的信息
        //        [responseObject writeToFile:@"/Users/yangboxing/Desktop/more.plist" atomicTopicy:YES];
        //        for (int i = 0; i < moreTopics.count; i ++) {
        //            if (moreTopics[i].top_cmt.count) {
        //                CLLog(@"%d",i);
        //            }
        //        }
        
        
        [weakSelf.topicArr addObjectsFromArray:moreTopics];
        [weakSelf.tableView reloadData];
        CLLog(@"请求成功");
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CLLog(@"请求失败 -- %@",error);
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.topicArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CLTopicCellID];
    cell.topic = self.topicArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接返回cell的高度即可
    return self.topicArr[indexPath.row].cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLCommentViewController *commentVC = [[CLCommentViewController alloc]init];
    commentVC.topic = self.topicArr[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}


//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
