//
//  DYVideoController.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import "DYVideoController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "Manger.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//#define ScreenHeight self.view.bounds.size.height

//预加载值
#define PRELOAD_THRESHOLD 2


@interface DYVideoController ()

@end

@implementation DYVideoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 允许子控制器覆盖当前上下文

    self.definesPresentationContext = YES;

    
    [self setupData]; // 初始化数据
    [self setUpView];
//    [self setupNotifications]; // 注册通知
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil]; // 添加 KVO 监听


    //初始加载
    [self loadInitialData];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.data.count > 0) {
//        [self observeValueForKeyPath:@"currentIndex" ofObject:self change:nil context:nil];
//    }
    
}

- (void)setupData {
    _data = [NSMutableArray array];
    _awemeIdList = [NSMutableArray array];
    _currentIndex = 0;
    _isCurPlayerPause = NO;
    _pageSize = 2; // 默认每次加载2个
    _currentPage = 1;
    _hasMoreData = YES;
    _isLoading = NO;
        
        // 初始加载第一页视频ID
//    [self loadMoreAwemeId];
//    [self loadAwemeDetailsForNewId];
}

//初始加载
- (void)loadInitialData {
    // 初始设置2个视频ID（可以改为从服务器获取）
    [self.awemeIdList addObjectsFromArray:@[@"7482354135765880091",@"7477984552787397946"]];
    
    // 加载初始视频详情
    [self loadAwemeDetailsForCurrentIds];
}


- (void)loadAwemeDetailsForCurrentIds {
    if (self.awemeIdList.count == 0) return;
    
    _isLoading = YES;
    
    // 创建一个调度组来跟踪所有请求
    dispatch_group_t group = dispatch_group_create();
    
    // 临时存储新加载的数据
    NSMutableArray *newData = [NSMutableArray array];
    
    for (NSString *videoId in self.awemeIdList) {
        dispatch_group_enter(group);
        
        [[Manger sharedSingleton] netWorkWithAweme:^(Aweme * _Nonnull aweme) {
            @synchronized (self) {
                [newData addObject:aweme];
            }
            dispatch_group_leave(group);
        } andError:^(NSError * _Nonnull error) {
            NSLog(@"加载视频ID %@ 失败: %@", videoId, error);
            dispatch_group_leave(group);
        } andVideoID:videoId];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        // 按原始ID顺序排序
        NSMutableArray *sortedData = [NSMutableArray array];
        for (NSString *videoId in strongSelf.awemeIdList) {
            for (Aweme *aweme in newData) {
                if ([aweme.aweme_id isEqualToString:videoId]) {
                    [sortedData addObject:aweme];
                    break;
                }
            }
        }
        
        [strongSelf.data addObjectsFromArray:sortedData];
        [strongSelf.tableView reloadData];
        
        strongSelf->_isLoading = NO;
        
        // 重置当前索引（如果需要）
        if (strongSelf.currentIndex >= strongSelf.data.count) {
            strongSelf.currentIndex = strongSelf.data.count - 1;
            NSLog(@"重制了当前索引");
        }
        
        // 数据加载完成后，手动触发第一个视频的播放
        if (sortedData.count > 0) {
            [strongSelf observeValueForKeyPath:@"currentIndex" ofObject:strongSelf change:nil context:nil];
        }
    });
}

//网络请求获得视频ID
-(void)loadMoreAwemeId {
    if (_isLoading || !_hasMoreData) return;
    
    _isLoading = YES;
    NSInteger nextPage = _currentPage + 1;
    NSLog(@"nextPage:%ld",(long)nextPage);
    NSLog(@"currentPage:%ld",(long)_currentPage);
    
    [[Manger sharedSingleton] netWorkWithVideoId:^(NSArray * _Nonnull videoIDArray) {
        NSLog(@"视频ID:%@",videoIDArray);
        if (!videoIDArray || videoIDArray == (id)[NSNull null] || ![videoIDArray isKindOfClass:[NSArray class]]) {
                    NSLog(@"获取的数组为空或无效");
                    self->_isLoading = NO;
                    return;
                }
        
        if (videoIDArray.count > 0) {
                    // 去重处理，避免重复添加相同的视频ID
                    NSMutableArray *newIDs = [NSMutableArray array];
                    for (NSString *videoId in videoIDArray) {
                        if (![self.awemeIdList containsObject:videoId]) {
                            [newIDs addObject:videoId];
                        }
                    }
                    
                    if (newIDs.count > 0) {
                        [self.awemeIdList addObjectsFromArray:newIDs];
                        self->_currentPage = nextPage;
                        NSLog(@"正在加载视频newIDs：%@",newIDs);
                        // 加载新ID的视频详情
                        [self loadAwemeDetailsForNewIds:newIDs];
                    } else {
                        // 没有新数据
                        self->_hasMoreData = NO;
                        self->_isLoading = NO;
                    }
                } else {
                    // 没有更多数据
                    self->_hasMoreData = NO;
                    self->_isLoading = NO;
                }
        
        NSLog(@"awemeIdlistID%@",self->_awemeIdList);
        } andError:^(NSError * _Nonnull error) {
            NSLog(@"视频Id获取失败");
            self->_isLoading = NO;
        } andCurrentIndex:nextPage];
}

// 加载新获取的ID的视频详情
- (void)loadAwemeDetailsForNewIds:(NSArray *)newAwemeIDs {
    if (newAwemeIDs.count == 0) {
        _isLoading = NO;
        return;
    }
    
    // 创建一个调度组来跟踪所有请求
    dispatch_group_t group = dispatch_group_create();
    
    // 临时存储新加载的数据
    NSMutableArray *newData = [NSMutableArray array];
    
    for (NSString *videoId in newAwemeIDs) {
        dispatch_group_enter(group);
        
        [[Manger sharedSingleton] netWorkWithAweme:^(Aweme * _Nonnull aweme) {
            @synchronized (self) {
                [newData addObject:aweme];
            }
            dispatch_group_leave(group);
        } andError:^(NSError * _Nonnull error) {
            NSLog(@"加载视频ID %@ 失败: %@", videoId, error);
            dispatch_group_leave(group);
        } andVideoID:videoId];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        // 按原始ID顺序排序
        NSMutableArray *sortedData = [NSMutableArray array];
        for (NSString *videoId in newAwemeIDs) {
            for (Aweme *aweme in newData) {
                if ([aweme.aweme_id isEqualToString:videoId]) {
                    [sortedData addObject:aweme];
                    break;
                }
            }
        }
        
        //原本更新方法
//        [strongSelf.data addObjectsFromArray:sortedData];
//        [strongSelf.tableView reloadData];
        
        //平滑更新
        if (sortedData.count > 0) {
            NSInteger originalCount = strongSelf.data.count;
            [strongSelf.data addObjectsFromArray:sortedData];
                    
            // 使用beginUpdates和endUpdates来平滑更新
            [strongSelf.tableView beginUpdates];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = originalCount; i < originalCount + sortedData.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [strongSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf.tableView endUpdates];
                }
        
        strongSelf->_isLoading = NO;
    });
}

//网络请求得到视频具体内容,数据加载
//-(void)loadAwemeDetailsForNewId:(NSArray *) newAwemeID{
//    
//    NSString *videoID1 = @"7448118827402972455";
//
//    [[Manger sharedSingleton] netWorkWithAweme:^(Aweme * _Nonnull aweme) {
//        
//        NSLog(@"Video URL: %@", aweme.video.play_addr.url_list.firstObject);
//        NSLog(@"Author: %@", aweme.author.nickname);
//        NSLog(@"Digg count: %ld", (long)aweme.statistics.digg_count);
//        
//        [self.data addObject:aweme];
//        
//        
//        } andError:^(NSError * _Nonnull error) {
//            NSLog(@"Aweme网络请求获取失败");
//        } andVideoID:videoID1];
//    
//}



-(void)setUpView {
    self.view.layer.masksToBounds = YES;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -ScreenHeight - 55, ScreenWidth, self.view.frame.size.height * 3)];
    self.tableView.contentInset = UIEdgeInsetsMake(ScreenHeight , 0, ScreenHeight * 1, 0);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerClass:[DYVideoCell class] forCellReuseIdentifier:@"DYVideoCell"];
    [self.view addSubview:self.tableView];
}

//- (void)setCurrentIndex:(NSInteger)currentIndex {
//    _currentIndex = currentIndex;
//}
//前台后台
//- (void)setupNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//}

#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DYVideoCell" forIndexPath:indexPath];
    cell.delegate = self;

    Aweme *aweme = self.data[indexPath.row];
        
        // 2. 从 Aweme 对象中提取视频 URL（确保 play_addr.url_list 不为空）
        if (aweme.video.play_addr.url_list.count > 0) {
            NSString *videoURLString = aweme.video.play_addr.url_list.firstObject;
            NSURL *videoURL = [NSURL URLWithString:videoURLString];
            
            // 3. 将 URL 传递给 Cell
            [cell setVideoURL:videoURL];
        } else {
            NSLog(@"⚠️ 视频 URL 不存在，检查数据解析是否正确");
        }
    [cell initData:aweme];
   
    // 如果是最后一个cell且正在加载更多，显示加载指示器
    if (indexPath.row == self.data.count - 1 && _isLoading) {
        // 添加加载指示器
    }
    
    return cell;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
}

// 在 DYVideoCell 的代理方法中修改
- (void)videoCellDidTapComment:(DYVideoCell *)cell {
    XXVideoCommentController *commentsVC = [[XXVideoCommentController alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    commentsVC.awemeId = self.awemeIdList[indexPath.row];

    // 关键设置1：设置模态呈现样式为覆盖当前上下文
    commentsVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    // 关键设置2：设置过渡样式
    commentsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    // 关键设置3：确保透明背景生效
    commentsVC.view.backgroundColor = [UIColor clearColor];
    

    [self presentViewController:commentsVC animated:YES completion:nil];
}



#pragma scrollerViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    
//    // 检查是否需要预加载更多数据
//    NSInteger currentRow = self.currentIndex;
//    NSInteger totalRows = self.data.count;
//    
//    // 当滑动到倒数第PRELOAD_THRESHOLD个时，加载更多
//    if (currentRow >= totalRows - PRELOAD_THRESHOLD && !_isLoading && _hasMoreData) {
//        NSLog(@"执行了预加载");
//        [self loadMoreAwemeId];
//    }
//}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO; // 禁用滑动手势
        
        if (translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex++; // 向下滑动，索引递增
        }
        if (translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex--; // 向上滑动，索引递减
        }
        NSLog(@"当前的currentIndex:%ld",(long)self.currentIndex);
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            scrollView.panGestureRecognizer.enabled = YES; // 启用滑动手势
            
            //滑动到最后一个视频，加载新的数据
            if (self.currentIndex == self.data.count - 1 && !self->_isLoading && self->_hasMoreData) {
                NSLog(@"加载新数据");
                NSLog(@"下载currentIndex:%ld",(long)self.currentIndex);
                    [self loadMoreAwemeId];
                }
        }];
    });
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        _isCurPlayerPause = NO;
        DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [cell play]; // 播放当前视频
        cell.pauseIcon.alpha = 0.0f;
        [cell.pauseIcon setHidden:YES];

        //NSLog(@"成功播放");
    }
}

#pragma Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"======== dealloc =======");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//加载当前ID列表中的视频详情
//- (void)loadAwemeDetailsForCurrentIds {
//    if (self.awemeIdList.count == 0) return;
//
//    _isLoading = YES;
//
//    // 创建一个调度组来跟踪所有请求
//    dispatch_group_t group = dispatch_group_create();
//
//    // 临时存储新加载的数据
//    NSMutableArray *newData = [NSMutableArray array];
//
//    for (NSString *videoId in self.awemeIdList) {
//        dispatch_group_enter(group);
//
//        [[Manger sharedSingleton] netWorkWithAweme:^(Aweme * _Nonnull aweme) {
//            @synchronized (self) {
//                [newData addObject:aweme];
//            }
//            dispatch_group_leave(group);
//        } andError:^(NSError * _Nonnull error) {
//            NSLog(@"加载视频ID %@ 失败: %@", videoId, error);
//            dispatch_group_leave(group);
//        } andVideoID:videoId];
//    }
//
//    __weak typeof(self) weakSelf = self;
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (!strongSelf) return;
//
//        // 按原始ID顺序排序
//        NSMutableArray *sortedData = [NSMutableArray array];
//        for (NSString *videoId in strongSelf.awemeIdList) {
//            for (Aweme *aweme in newData) {
//                if ([aweme.aweme_id isEqualToString:videoId]) {
//                    [sortedData addObject:aweme];
//                    break;
//                }
//            }
//        }
//
//        [strongSelf.data addObjectsFromArray:sortedData];
//        [strongSelf.tableView reloadData];
//
//        strongSelf->_isLoading = NO;
//
//        // 重置当前索引（如果需要）
//        if (strongSelf.currentIndex >= strongSelf.data.count) {
//            strongSelf.currentIndex = strongSelf.data.count - 1;
//        }
//    });
//}
@end
