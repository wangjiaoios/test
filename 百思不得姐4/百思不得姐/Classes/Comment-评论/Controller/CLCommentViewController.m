//
//  CLEssenceViewController.m
//  百思不得姐
//
//  Created by 杨博兴 on 16/9/21.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import "CLCommentViewController.h"
#import "CLTopic.h"
#import "CLHTTPSessionManager.h"
#import <MJRefresh.h>

@interface CLCommentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;


@property(nonatomic,strong)CLHTTPSessionManager *manger;

@end

@implementation CLCommentViewController

static NSString * const CommentTableViewID = @"commentTableView";


#pragma mark - 懒加载

-(CLHTTPSessionManager *)manger
{
    if (_manger == nil) {
        _manger = [CLHTTPSessionManager manager];
    }
    return _manger;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBase];
    [self setupTable];
    
    
    
}

- (void)setupBase
{
    self.navigationItem.title = @"评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setupTable
{
    // 注册cell
    [self.commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CommentTableViewID];
    // 关闭cell之间的线
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 创建heardView
    UIView *view =  [[UIView alloc]init];
    view.cl_height = 200;
    view.backgroundColor = [UIColor redColor];
    // 设置heardView
    self.commentTableView.tableHeaderView = view;
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
//    if (弹出) {
//        self.bottomMargin.constant = 键盘高度;
//    } else {
//        self.bottomMargin.constant = 0;
//    }
    
    // 修改约束  屏幕的高度 - 键盘的y值
    CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    self.bottomMargin.constant = screenH - keyboardY;
    
    // 执行动画
    // 获取执行动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        // 更新约束
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - <UITableViewDataSource>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentTableViewID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd - %zd",indexPath.section,indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"最热评论";
    }
    return @"所有评论";
}

#pragma mark - <UITableViewDelegate>
/**
 *  当用户开始拖拽scrollView就会调用一次
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end