//
//  ProfileView.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "ProfileView.h"
#import "Masonry/Masonry.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "VideoCell.h"

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGTH ([UIScreen mainScreen].bounds.size.heigth)

@implementation ProfileView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self fetchProfileData];
        [self fetchVideosData];
    }
    return self;
}

#pragma mark - 个人页面UI布局

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.avatarImage = [[UIImageView alloc] init];
    self.avatarImage.image = [UIImage imageNamed:@"placeholder_avatar"];
    self.avatarImage.layer.cornerRadius = 40;
    self.avatarImage.layer.masksToBounds = YES;
    [self addSubview:self.avatarImage];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"placeholder_name";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;//设置文本居中对齐
    [self addSubview:self.nameLabel];
    
    self.fansLabel = [[UILabel alloc] init];
    self.fansLabel.text = @"粉丝：placedolder_fans";
    self.fansLabel.font = [UIFont systemFontOfSize:14];
    self.fansLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.fansLabel];
    
    self.followsLabel = [[UILabel alloc] init];
    self.followsLabel.text = @"关注：placedolder_follows";
    self.followsLabel.font = [UIFont systemFontOfSize:14];
    self.followsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.followsLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//布局方向为垂直流布局
    layout.minimumLineSpacing = 2; // 行间距
    layout.minimumInteritemSpacing = 0; // 列间距
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"VideoCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    // 使用 Masonry 布局
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(50);
        make.centerX.equalTo(self);
    }];
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(50);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.followsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(50);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fansLabel.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self);
    }];
}
    
#pragma mark - 网络请求

- (void)fetchProfileData {
    // 模拟网络请求获取个人数据
    NSString *url = @"https://api.example.com/profile";
    [[AFHTTPSessionManager manager] GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 更新 UI
        self.nameLabel.text = responseObject[@"name"];
        self.fansLabel.text = [NSString stringWithFormat:@"粉丝：%@", responseObject[@"fans"]];
        self.followsLabel.text = [NSString stringWithFormat:@"关注：%@", responseObject[@"follow"]];
//        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败: %@", error);
    }];
}

- (void)fetchVideosData {
    // 模拟网络请求获取视频数据
    NSString *url = @"https://v.douyin.com/L4FJNR3/";
    [[AFHTTPSessionManager manager] GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.videos = responseObject[@"videos"];
        [self.collectionView reloadData]; // 刷新瀑布流
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败: %@", error);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
//    return self.videos.count;
}

//返回分区个数（这个方法并不一定要实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 250 / 250.0 alpha:1];
    return cell;
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
//
    
//    // 获取视频数据
//    NSDictionary *video = self.videos[indexPath.item];
//    NSString *imageURL = video[@"cover"];
//    NSString *title = video[@"title"];
//    
//    // 配置 cell
//    [cell configureWithImageURL:imageURL title:title];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 随机高度，模拟瀑布流
//    CGFloat height = arc4random_uniform(100) + 100;
    CGFloat height = 300;
    CGFloat width = (self.frame.size.width - 2) / 2;
    return CGSizeMake(width, height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
