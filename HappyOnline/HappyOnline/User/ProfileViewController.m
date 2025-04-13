//
//  ProfileViewController.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "ProfileViewController.h"
//#import "ProfileView.h"
#import "VideoCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundImage2.jpg"];
    // 获取视图的图层
    CALayer *layer = self.view.layer;
    // 设置图层的内容为图片
    layer.contents = (id)backgroundImage.CGImage;
    // 设置图层的内容模式
    layer.contentsGravity = kCAGravityResizeAspectFill;
    
    // 初始化视频URL
    NSString *filePath1 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/441_1744548127.mp4";
    NSString *filePath2 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/443_1744548223.mp4";
    NSString *filePath3 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/444_1744548224.mp4";
    NSString *filePath4 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/445_1744548238.mp4";
    NSString *filePath5 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/446_1744548247.mp4";
    NSString *filePath6 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/447_1744548269.mp4";
    NSString *filePath7 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/448_1744548275.mp4";
    NSString *filePath8 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/449_1744548309.mp4";
    NSString *filePath9 = @"/Users/duobi/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/0a3a9c6b1aa6d944993290e490800b76/Message/MessageTemp/9e20f478899dc29eb19741386f9343c8/Video/450_1744548318.mp4";
    
    self.videoURLs = @[
        [[NSURL alloc] initFileURLWithPath:filePath1],
        [[NSURL alloc] initFileURLWithPath:filePath2],
        [[NSURL alloc] initFileURLWithPath:filePath3],
        [[NSURL alloc] initFileURLWithPath:filePath4],
        [[NSURL alloc] initFileURLWithPath:filePath5],
        [[NSURL alloc] initFileURLWithPath:filePath6],
        [[NSURL alloc] initFileURLWithPath:filePath7],
        [[NSURL alloc] initFileURLWithPath:filePath8],
        [[NSURL alloc] initFileURLWithPath:filePath9]
    ];
    self.favoritesData = @[@"喜欢1", @"喜欢2", @"喜欢3"];
    
    // 设置容器滚动视图
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.containerScrollView.delegate = self;
    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2); // 高度根据需要调整
    //1.禁止scrollView在竖直方向上滑动
//    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0); // 高度设为 0
    [self.view addSubview:self.containerScrollView];
    
    // 设置个人信息区域
    [self setupHeaderView];
    
    // 设置分栏控件
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"作品", @"我的喜欢"]];
    self.segmentedControl.frame = CGRectMake(20, CGRectGetMaxY(self.headerView.frame) + 10, self.view.frame.size.width - 40, 30);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    [self.containerScrollView addSubview:self.segmentedControl];
    
    // 记录分栏控件的初始 Y 坐标
    self.segmentControlOffsetY = CGRectGetMinY(self.segmentedControl.frame);
    
    // 设置瀑布流布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 4) / 3, 200); //两列瀑布流
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    // 创建 CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMinY(self.segmentedControl.frame) - 10) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"VideoCell"];
    [self.containerScrollView addSubview:self.collectionView];
//    ProfileView *profileView = [[ProfileView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:profileView];
    
//    //2.手势处理（滑动时 UIScrollView和UICollectionView的优先级）
//    for (UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers) {
//        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
//            [gesture addTarget:self action:@selector(handleCollectionPan:)];
//        }
//    }
    
    self.isCollectionViewAtBottom = NO;
}

// 设置个人信息区域
- (void)setupHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.headerView.backgroundColor = [UIColor clearColor];
    
    // 头像
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    avatarImageView.image = [UIImage imageNamed:@"touxiang.jpg"]; // 替换为实际头像
    avatarImageView.layer.cornerRadius = 30;
    avatarImageView.clipsToBounds = YES;
    [self.headerView addSubview:avatarImageView];
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, 20, 200, 20)];
    nameLabel.text = @"诉枯夏";
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.headerView addSubview:nameLabel];
    
    // ID
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, CGRectGetMaxY(nameLabel.frame) + 5, 200, 20)];
    idLabel.text = @"ID: 1234567";
    idLabel.font = [UIFont systemFontOfSize:14];
    idLabel.textColor = [UIColor grayColor];
    [self.headerView addSubview:idLabel];
        
    // 粉丝数
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(avatarImageView.frame) + 20, 100, 20)];
    fansLabel.text = @"粉丝: 1001";
    fansLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:fansLabel];
    
    // 关注数
    UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fansLabel.frame) + 20, CGRectGetMaxY(avatarImageView.frame) + 20, 100, 20)];
    followLabel.text = @"关注: 500";
    followLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:followLabel];
    
    // 个人介绍
    UILabel *bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fansLabel.frame) + 10, self.view.frame.size.width - 40, 40)];
    bioLabel.text = @"这个人很懒，什么也没有写～";
    bioLabel.font = [UIFont systemFontOfSize:14];
    bioLabel.numberOfLines = 2;
    [self.headerView addSubview:bioLabel];
    
    [self.containerScrollView addSubview:self.headerView];
}

// 分栏切换事件
- (void)segmentChanged {
    [self.collectionView reloadData]; // 刷新数据
}

//#pragma mark - 手势处理
//- (void)handleCollectionPan:(UIPanGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        self.containerScrollView.scrollEnabled = NO;
//    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
//        // 结束滑动时恢复外层滚动
//        self.containerScrollView.scrollEnabled = YES;
//    }
//}

#pragma mark - UIScrollViewDelegate
// 监听滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.containerScrollView) {
        //一、分栏顶部固定
        CGFloat offsetY = scrollView.contentOffset.y;
        // 如果分栏控件滚动到顶部，固定其位置
        if (offsetY >= self.segmentControlOffsetY - 50) {
            self.segmentedControl.frame = CGRectMake(20, offsetY + 50, self.view.frame.size.width - 40, 30);
            self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMinY(self.segmentedControl.frame) - 10);
        } else {
            self.segmentedControl.frame = CGRectMake(20, self.segmentControlOffsetY, self.view.frame.size.width - 40, 30);
            self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMinY(self.segmentedControl.frame) - 10);
        }
        //二、滚动限制
        if (self.isCollectionViewAtBottom && offsetY > CGRectGetMaxY(self.headerView.frame)) {
            scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.headerView.frame));
        }
    } else if (scrollView == self.collectionView) {
        // 检测集合视图是否滑动到底部
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat frameHeight = scrollView.frame.size.height;
        
        self.isCollectionViewAtBottom = (offsetY >= contentHeight - frameHeight - 1);
        self.endIndicator.hidden = !self.isCollectionViewAtBottom;
        
        if (self.isCollectionViewAtBottom && offsetY > contentHeight - frameHeight) {
            scrollView.contentOffset = CGPointMake(0, contentHeight - frameHeight);
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.segmentedControl.selectedSegmentIndex == 0) ? self.videoURLs.count : self.favoritesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.videoURL = self.videoURLs[indexPath.row]; // 设置视频 URL
    
//    NSString *title = (self.segmentedControl.selectedSegmentIndex == 0) ? self.videoURLs[indexPath.row] : self.favoritesData[indexPath.row];
//    cell.titleLabel.text = title;
//    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 当单元格离开屏幕时暂停播放
    if ([cell isKindOfClass:[VideoCell class]]) {
        VideoCell *videoCell = (VideoCell *)cell;
        [videoCell.player pause];
    }
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
