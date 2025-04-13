//
//  XXVideoCommentController.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "XXVideoCommentController.h"
#import "XXCommentCell.h"
#import "Masonry.h"
#import "MJRefresh.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface XXVideoCommentController ()

@end

@implementation XXVideoCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    // 添加模糊效果
       UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
       UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
       blurView.frame = self.view.bounds;
       [self.view addSubview:blurView];
       
       // 添加你的评论内容容器视图
       self.container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight * 0.3, ScreenWidth, ScreenHeight * 0.7)];
       self.container.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:self.container];
       
       // 添加关闭按钮
       UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
       [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
       [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
       [self.container addSubview:closeButton];
       
       // 设置圆角
       self.container.layer.cornerRadius = 10;
       self.container.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    self.viewModel = [[CommentViewModel alloc] init];
    self.viewModel.awemeId = self.awemeId; // 设置视频ID

    [self setupUI];
    [self loadData];
}

-(void)setupUI {
    
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:_headerView]; // 添加到container

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"评论";
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_titleLabel];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"''"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_closeButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension; // 关键设置
    _tableView.estimatedRowHeight = 100;
    [_tableView registerClass:[XXCommentCell class] forCellReuseIdentifier:[XXCommentCell reuseIdentifier]];
    [self.container addSubview:_tableView]; // 添加到container

    
     //添加下拉刷新和上拉加载
     _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
     _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self setupConstraints];

}

- (void)setupConstraints {
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.container);
        make.height.mas_equalTo(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_headerView);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerView);
        make.right.equalTo(_headerView).offset(-15);
        make.width.height.mas_equalTo(30);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.container);
    }];
}


- (void)loadData {
    NSLog(@"进入loadData");
    [self.viewModel loadCommentsWithSuccess:^(NSArray *comments, BOOL hasMore) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        NSLog(@"loadData中ViewModel的course:%ld",(long)self.viewModel.cursor);
        
        if (!hasMore) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"加载评论失败: %@", error.localizedDescription);
        // 这里可以添加错误提示
    }];
}

- (void)loadMoreData {
    NSLog(@"进入loadMoreData");

    [self.viewModel loadMoreCommentsWithSuccess:^(NSArray *comments, BOOL hasMore) {
        if (hasMore) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        NSLog(@"loadMoreData中ViewModel的course:%ld",(long)self.viewModel.cursor);

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"加载更多评论失败: %@", error.localizedDescription);
        // 这里可以添加错误提示
    }];
}


- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[XXCommentCell reuseIdentifier] forIndexPath:indexPath];
    cell.comment = self.viewModel.comments[indexPath.row];
//    NSLog(@"评论图片：%@",cell.comment.imageList);
//    NSLog(@"评论内容:%@",cell.comment.text);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *comment = self.viewModel.comments[indexPath.row];
    return [comment cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击评论可以展开二级评论
    CommentModel *comment = self.viewModel.comments[indexPath.row];
    if (comment.replyCommentTotal > 0) {
        // TODO: 展开二级评论
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
//- (void)loadData {
//    [self.viewModel loadCommentsWithCompletion:^(BOOL success, NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        if (success) {
//            [self.tableView reloadData];
//        } else {
//            // 显示错误信息
//            NSLog(@"加载评论失败: %@", error.localizedDescription);
//        }
//    }];
//}
////
//- (void)loadMoreData {
//    [self.viewModel loadMoreCommentsWithCompletion:^(BOOL success, NSError *error) {
//        [self.tableView.mj_footer endRefreshing];
//        if (success) {
//            [self.tableView reloadData];
//        } else {
//            // 显示错误信息
//            NSLog(@"加载更多评论失败: %@", error.localizedDescription);
//        }
//    }];
//}
