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

// 将十六进制颜色码转换为UIColor对象的方法
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return [UIColor whiteColor];
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

#pragma mark - 个人页面UI布局

- (void)setupUI {
//    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *avatarImage = [UIImage imageNamed:@"touxiang.jpg"];
        
    // 创建UIImageView并设置其大小，这里设置为100x100
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    avatarImageView.image = avatarImage;
    
    // 设置内容模式，保证图片按比例填充
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 裁剪超出边界的部分
    avatarImageView.clipsToBounds = YES;
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"touxiang.jpg"];
    self.avatarImageView.layer.cornerRadius = 40;
    self.avatarImageView.layer.masksToBounds = YES;
    [self addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"诉枯夏";
    self.nameLabel.font = [UIFont systemFontOfSize:25];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;//设置文本居中对齐
    [self addSubview:self.nameLabel];
    
    self.fansLabel = [[UILabel alloc] init];
    self.fansLabel.text = @"粉丝：13w";
    self.fansLabel.font = [UIFont systemFontOfSize:17];
    self.fansLabel.textColor = [ProfileView colorWithHexString:@"#101010"];
    self.fansLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.fansLabel];
    
    self.followsLabel = [[UILabel alloc] init];
    self.followsLabel.text = @"关注：327";
    self.followsLabel.font = [UIFont systemFontOfSize:17];
    self.followsLabel.textAlignment = NSTextAlignmentCenter;
    self.followsLabel.textColor = [UIColor blackColor];
    [self addSubview:self.followsLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//布局方向为垂直流布局
    layout.minimumLineSpacing = 2; // 行间距
    layout.minimumInteritemSpacing = 0; // 列间距
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"VideoCell"];
    
    [self.collectionView registerClass:[SegmentView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SegmentView"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    // 使用 Masonry 布局
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(60);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(30);
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
    return 12;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SegmentView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SegmentView" forIndexPath:indexPath];
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//     随机高度，模拟瀑布流
//    CGFloat height = arc4random_uniform(100) + 100;
    CGFloat spacing = 2;//间距
    CGFloat height = 200;
    CGFloat width = (self.frame.size.width - spacing) / 3;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 50); // 分栏高度
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat segmentViewHeight = 50; // 分栏高度
    CGFloat pinnedOffsetY = CGRectGetMaxY(self.followsLabel.frame) + 20; // 分栏固定时的偏移量
    
    if (offsetY >= pinnedOffsetY) {
        if (!self.isSegmentViewPinned) {
            self.isSegmentViewPinned = YES;
            [self pinSegmentViewToTop];
        }
    } else {
        if (self.isSegmentViewPinned) {
            self.isSegmentViewPinned = NO;
            [self unpinSegmentView];
        }
    }
}

- (void)pinSegmentViewToTop {
    // 将分栏固定在顶部
    [self.segmentView removeFromSuperview];
    [self addSubview:self.segmentView];
    [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followsLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

- (void)unpinSegmentView {
    // 将分栏恢复到原来的位置
    [self.segmentView removeFromSuperview];
    [self.collectionView addSubview:self.segmentView];
    [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView).offset(CGRectGetMaxY(self.followsLabel.frame) + 20);
        make.left.right.equalTo(self.collectionView);
        make.height.mas_equalTo(50);
    }];
}

//- (void)setupRefreshControl {
//    // 创建 UIRefreshControl
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.tintColor = [UIColor grayColor]; // 设置菊花颜色
//    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
//    
//    // 将 UIRefreshControl 添加到 UICollectionView
//    self.collectionView.refreshControl = self.refreshControl;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
