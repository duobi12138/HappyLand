//
//  VideoCell.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "VideoCell.h"
#import "Masonry/Masonry.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        // 初始化播放器
        self.player = [[AVPlayer alloc] init];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.contentView.layer addSublayer:self.playerLayer];
        
        //添加长按手势识别器
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGesture.minimumPressDuration = 0.3; // 设置长按时间
        [self.contentView addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    // 重置播放器
    [self.player pause];
    self.player = nil;
    self.playerLayer.player = nil;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    if (videoURL) {
        NSLog(@"视频 URL: %@", videoURL);
        
        // 创建 AVPlayerItem
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        
        // 设置 AVPlayerLayer
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.contentView.layer addSublayer:self.playerLayer];
        
        // 监听播放器状态
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        // 自动播放
//        [self.player play];
    } else {
        NSLog(@"视频 URL 无效");
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 长按开始，播放视频
        [self.player play];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        // 长按结束或取消，暂停视频
        [self.player pause];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"视频已准备好播放");
        } else if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"视频加载失败: %@", self.player.error);
        }
    } else {
        // 处理其他监听事件
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status"];
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}
//
//- (void)setupUI {
//    // 1. 视频封面
//    self.coverImageView = [[UIImageView alloc] init];
//    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.coverImageView.clipsToBounds = YES;
//    self.coverImageView.backgroundColor = [UIColor lightGrayColor]; // 默认背景色
//    [self.contentView addSubview:self.coverImageView];
//
//    // 2. 视频标题
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.titleLabel];
//
//    // 使用 Masonry 布局
//    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.contentView);
//        make.height.mas_equalTo(20);
//    }];
//}
//
//- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title {
//    // 加载封面图片（使用 SDWebImage 或 AFNetworking）
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    self.titleLabel.text = title;
//}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
//                                              green:arc4random() % 255 / 255.0
//                                               blue:arc4random() % 255 / 255.0
//                                              alpha:1];
//    }
//    return self;
//}
//
//

- (void)configureWithImageURL:(nonnull NSString *)imageURL title:(nonnull NSString *)title {
    
}

@end
