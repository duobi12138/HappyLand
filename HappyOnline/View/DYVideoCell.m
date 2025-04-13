//
//  DYVideoCell.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import "DYVideoCell.h"
#import "AVPlayerView.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "WebCache.h"

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ColorWhiteAlpha80 RGBA(255.0, 255.0, 255.0, 0.8)
#define SafeAreaBottomHeight ((ScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;

@implementation DYVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor blackColor];
//        [self initPlayerView];
//        [self initSubviews]; // 初始化其他控件
//
//
//    }
//    return self;
//}

// 修改后初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        _cacheHelper = [WebCacheHelper sharedHelper]; // 初始化缓存帮助类
        [self initPlayerView];
        [self initSubviews];
    }
    return self;
}

// 初始化播放器视图
- (void)initPlayerView {
    _playerView = [AVPlayerView new];
    _playerView.delegate = self; // 设置代理
    [self.contentView addSubview:_playerView];
    
    // 设置约束
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

// 初始化其他控件
- (void)initSubviews {
    
    //创建容器视图
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:_singleTapGesture];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"videoPause.png"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = [UIColor whiteColor];
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    
    // 初始化进度条
    _progressView = [[UIProgressView alloc] init];
    _progressView.progressTintColor = [UIColor whiteColor]; // 已播放部分的颜色
    _progressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3]; // 未播放部分的颜色
    _progressView.progress = 0.0;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f); // 调整进度条高度
    [_container addSubview:_progressView];
        
    // 添加手势识别器
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleProgressPan:)];
    [_progressView addGestureRecognizer:panGesture];
    _progressView.userInteractionEnabled = YES;
    
    
    //UI
    _musicIcon = [[UIImageView alloc] init];
    _musicIcon.contentMode = UIViewContentModeCenter;
    //_musicIcon.image = [UIImage imageNamed:@"musicnote3.2.png"];
    [_container addSubview:_musicIcon];
    
    _musicName = [[CircleTextView alloc] init];
    _musicName.textColor = [UIColor whiteColor];
    _musicName.font = [UIFont systemFontOfSize:14.0];
    _musicName.text = @"@KD_B Music创作的原声";
    [_container addSubview:_musicName];
    
    _desc = [[UILabel alloc] init];
    _desc.numberOfLines = 0;
    _desc.textColor = ColorWhiteAlpha80;
    _desc.font = [UIFont systemFontOfSize:14.0];
    _desc.text = @"你对我的好我一直记得 因为只有你把我当小孩#双子座";
    [_container addSubview:_desc];
    
    _nickName = [[UILabel alloc] init];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = [UIFont boldSystemFontOfSize:16.0];
    _nickName.text = @"萧萧不吃辣";
    [_container addSubview:_nickName];
    
    _musicAlum = [MusciAlbumView new];
    [_container addSubview:_musicAlum];
    
    
    
    // 分享按钮
    _share = [[UIImageView alloc] init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"share2.png"];
    _share.userInteractionEnabled = YES;
    [_container addSubview:_share];
    
    _shareNum = [[UILabel alloc] init];
    _shareNum.text = @"0";
    _shareNum.textColor = [UIColor whiteColor];
    _shareNum.font = [UIFont systemFontOfSize:12.0];
    [_container addSubview:_shareNum];
    
    // 评论按钮
    _comment = [[UIImageView alloc] init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"comment2.png"];
    _comment.userInteractionEnabled = YES;
    [_container addSubview:_comment];
    
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction)];
        [_comment addGestureRecognizer:commentTap];
    
    _commentNum = [[UILabel alloc] init];
    _commentNum.text = @"0";
    _commentNum.textColor = [UIColor whiteColor];
    _commentNum.font = [UIFont systemFontOfSize:12.0];
    [_container addSubview:_commentNum];
    
    // 头像
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"img_find_default@2x.png"];
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.layer.cornerRadius = 25; // 圆x形头像
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.borderWidth = 1;
    [_container addSubview:_avatar];
    
    // 关注按钮
    _focus = [FocusView new];
    [_container addSubview:_focus];
    
    // 点赞按钮
    _favorite = [FavoriteView new];
    _favorite.delegate = self;
    [_container addSubview:_favorite];
    
    _favoriteNum = [[UILabel alloc] init];
    _favoriteNum.text = @"0";
    _favoriteNum.textColor = [UIColor whiteColor];
    _favoriteNum.font = [UIFont systemFontOfSize:12.0];
    [_container addSubview:_favoriteNum];
    
    // 设置控件约束
    [self setupConstraints];
}

// 设置控件约束
- (void)setupConstraints {
    CGFloat avatarRadius = 25;

    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(49.5f + SafeAreaBottomHeight);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];

    
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).inset(60 + SafeAreaBottomHeight);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(25);
    }];
    
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicIcon.mas_right);
        make.centerY.equalTo(self.musicIcon);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(24);
    }];
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.musicIcon.mas_top);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.desc.mas_top).inset(5);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/4*3 + 30);
    }];
    
    [_musicAlum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicName);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(50);
    }];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favorite.mas_top).inset(35);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.centerY.equalTo(self.avatar.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(15);
        make.bottom.equalTo(self).inset(5 + SafeAreaBottomHeight);
        make.height.mas_equalTo(2);
    }];
}


// 设置视频 URL
//- (void)setVideoURL:(NSURL *)url {
//    [_playerView setPlayerWithUrl:url.absoluteString];
//}

//- (void)setVideoURL:(NSURL *)url {
//    if (!url) return;
//    
//    __weak typeof(self) weakSelf = self;
//    
//    // 1. 先尝试从缓存获取
//    [self.cacheHelper queryVideoFromCacheWithURL:url completion:^(NSURL * _Nullable cachedFileURL) {
//        if (cachedFileURL) {
//            // 缓存命中，使用本地文件播放
//            [weakSelf.playerView setPlayerWithUrl:cachedFileURL.absoluteString];
//        } else {
//            // 缓存未命中，直接使用网络URL播放
//            [weakSelf.playerView setPlayerWithUrl:url.absoluteString];
//            
//            // 监听缓冲进度，当缓冲足够时进行缓存
//            [weakSelf.playerView.player.currentItem addObserver:weakSelf
//                                                     forKeyPath:@"loadedTimeRanges"
//                                                        options:NSKeyValueObservingOptionNew
//                                                        context:nil];
//        }
//    }];
//}

//old成功
//- (void)setVideoURL:(NSURL *)url {
//    if (!url) return;
//    
//    __weak typeof(self) weakSelf = self;
//    
//    // 告诉 AVPlayerView 需要监听缓冲进度（用于缓存）
//    self.playerView.shouldObserveLoadedTimeRanges = YES;
//    
//    [self.cacheHelper queryVideoFromCacheWithURL:url completion:^(NSURL * _Nullable cachedFileURL) {
//        if (cachedFileURL) {
//            // 缓存命中，使用本地文件播放（不需要监听缓冲进度）
//            NSLog(@"缓存命中，使用本地文件播放: %@", cachedFileURL.absoluteString);  // 打印缓存命中信息
//
//            weakSelf.playerView.shouldObserveLoadedTimeRanges = NO;
//            [weakSelf.playerView setPlayerWithUrl:cachedFileURL.absoluteString];
//        } else {
//            // 缓存未命中，使用网络URL播放（会自动监听缓冲进度）
//            NSLog(@"缓存未命中，使用网络URL播放: %@", url.absoluteString);  // 打印缓存未命中信息
//
//            [weakSelf.playerView setPlayerWithUrl:url.absoluteString];
//        }
//    }];
//}


//new poe
- (void)setVideoURL:(NSURL *)url {
    if (!url) return;

    __weak typeof(self) weakSelf = self;
    [self.cacheHelper queryVideoFromCacheWithURL:url completion:^(NSURL * _Nullable cachedFileURL) {
        if (cachedFileURL) {
            // 缓存命中，直接将缓存文件URL传递给AVPlayerView
            NSLog(@"缓存命中，使用本地文件播放: %@", cachedFileURL.absoluteString);
            [weakSelf.playerView setPlayerWithUrl:cachedFileURL.absoluteString];
        } else {
            // 缓存未命中，将原始URL传递给AVPlayerView
            NSLog(@"缓存未命中，使用网络URL播放: %@", url.absoluteString);
            [weakSelf.playerView setPlayerWithUrl:url.absoluteString];
        }
    }];
}


// 监听缓冲进度
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                       context:(void *)context {
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        AVPlayerItem *playerItem = (AVPlayerItem *)object;
//        NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
//        if (loadedTimeRanges.count > 0) {
//            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
//            Float64 bufferDuration = CMTimeGetSeconds(timeRange.duration);
//            
//            // 当缓冲超过10秒或缓冲完成时，尝试缓存
//            Float64 totalDuration = CMTimeGetSeconds(playerItem.duration);
//            if (bufferDuration > 10 || bufferDuration >= totalDuration) {
//                [self cacheCurrentVideoIfNeeded];
//            }
//        }
//    }
//}
//
//// 缓存当前视频
//- (void)cacheCurrentVideoIfNeeded {
//    AVURLAsset *asset = (AVURLAsset *)self.playerView.player.currentItem.asset;
//    if (![asset isKindOfClass:[AVURLAsset class]]) return;
//    
//    NSURL *remoteURL = asset.URL;
//    if (remoteURL.isFileURL) return; // 不缓存本地文件
//    
//    // 检查是否已经缓存过
//    NSString *key = [self.cacheHelper cacheKeyForURL:remoteURL];
//    if ([[XXWebCache sharedCache] diskCacheExistsForKey:key]) return;
//    
//    // 异步读取数据并缓存
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *videoData = [NSData dataWithContentsOfURL:remoteURL];
//        if (videoData) {
//            [self.cacheHelper storeVideoData:videoData forURL:remoteURL];
//        }
//    });
//}

// 准备重用
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    _isPlayerReady = NO;
////    [_playerView cancelLoading]; // 取消加载
//    [_favorite resetView]; // 重置点赞按钮状态
//    [_focus resetView]; // 重置关注按钮状态
//    _avatar.image = nil; // 清空头像
//    _progressView.progress = 0.0;
//    _currentProgress = 0.0;
//    _totalDuration = 0.0;
//    self.pauseIcon.alpha = 0.0f;
//    [self.pauseIcon setHidden:YES];
//
//}

//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    _isPlayerReady = NO;
//    
//    // 移除观察者
//    [self.playerView.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    
//    [_playerView cancelLoading];
//    [_favorite resetView];
//    [_focus resetView];
//    _avatar.image = nil;
//    _progressView.progress = 0.0;
//    _currentProgress = 0.0;
//    _totalDuration = 0.0;
//    self.pauseIcon.alpha = 0.0f;
//    [self.pauseIcon setHidden:YES];
//}

- (void)prepareForReuse {
    [super prepareForReuse];
    _isPlayerReady = NO;
    [self.playerView cancelLoading];
    [_favorite resetView];
    [_focus resetView];
    _avatar.image = nil;
    _progressView.progress = 0.0;
    _currentProgress = 0.0;
    _totalDuration = 0.0;
    self.pauseIcon.alpha = 0.0f;
    [self.pauseIcon setHidden:YES];
}

// 处理进度条拖动手势
- (void)handleProgressPan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_progressView];
    CGFloat progress = point.x / _progressView.bounds.size.width;
    progress = MAX(0.0, MIN(1.0, progress));
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [_playerView pause]; // 开始拖动时暂停视频
            break;
            
        case UIGestureRecognizerStateChanged:
            _progressView.progress = progress;
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 计算目标时间
            CGFloat targetTime = progress * _totalDuration;
            // 跳转到指定时间
            [_playerView seekToTime:targetTime completionHandler:^(BOOL finished) {
                if (finished) {
                    [self->_playerView play]; // 跳转完成后继续播放
                    self.pauseIcon.alpha = 0.0f;
                    [self.pauseIcon setHidden:YES];

                }
            }];
            break;
        }
            
        default:
            break;
    }
}

// 实现 AVPlayerUpdateDelegate 的进度更新方法
- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    _currentProgress = current;
    _totalDuration = total;
    [self updateProgress:(current / total)];
}

// 更新进度条
- (void)updateProgress:(CGFloat)progress {
    [UIView animateWithDuration:0.1 animations:^{
        [self->_progressView setProgress:progress animated:YES];
    }];
}

// 播放
- (void)play {
    [_playerView play];
}

// 暂停
- (void)pause {
    [_playerView pause];
}

// 重新播放
- (void)replay {
    [_playerView replay];
}

//暂停和点赞手势
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
            // 处理评论点击
            break;
        }
        case kAwemeListLikeShareTag: {
            // 处理分享点击
            break;
        }
        default: {
            // 获取点击坐标和时间
            CGPoint point = [sender locationInView:_container];
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            // 判断是否为双击
            if(time - _lastTapTime > 0.25f) {
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            } else {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
                
                if (!_favorite.isFavorite) { // 如果未点赞，则触发点赞
                    [self showLikeViewAnim:point oldPoint:_lastTapPoint]; // 显示爱心动画
                    _favorite.isFavorite = YES; // 切换点赞状态
                    [self updateFavoriteCount]; // 更新点赞数
                               }
            }
            _lastTapPoint = point;
            _lastTapTime = time;
            break;
        }
    }
}

////点赞数更新
//- (void)updateFavoriteCount {
//    NSInteger currentFavoriteCount = [_favoriteNum.text integerValue];
//    if (_favorite.isFavorite) {
//        currentFavoriteCount += 1; // 点赞数加1
//    } else {
//        currentFavoriteCount -= 1; // 点赞数减1
//    }
//    _favoriteNum.text = [NSString stringWithFormat:@"%ld", (long)currentFavoriteCount];
//}
//
//- (void)favoriteView:(FavoriteView *)favoriteView didTapFavorite:(BOOL)isFavorite {
//    // 更新点赞数
//    NSInteger currentFavoriteCount = [_favoriteNum.text integerValue];
//    if (isFavorite) {
//        currentFavoriteCount += 1; // 点赞数加1
//    } else {
//        currentFavoriteCount -= 1; // 点赞数减1
//    }
//    _favoriteNum.text = [NSString stringWithFormat:@"%ld", (long)currentFavoriteCount];
//}

// 更新点赞数方法
- (void)updateFavoriteCount {
    NSString *currentText = _favoriteNum.text;
    NSInteger currentCount = 0;
    
    // 处理带"w"的情况（如1.1w）
    if ([currentText containsString:@"w"]) {
        CGFloat wValue = [[currentText stringByReplacingOccurrencesOfString:@"w" withString:@""] floatValue];
        currentCount = wValue * 10000;
    } else {
        currentCount = [currentText integerValue];
    }
    
    // 根据点赞状态增减
    currentCount = _favorite.isFavorite ? currentCount + 1 : currentCount - 1;
    
    // 重新格式化显示
    _favoriteNum.text = [NSString formatCount:currentCount];
}

// FavoriteView代理方法也需要同步修改
- (void)favoriteView:(FavoriteView *)favoriteView didTapFavorite:(BOOL)isFavorite {
    [self updateFavoriteCount];
}

- (void)singleTapAction {
    // 处理播放/暂停逻辑
    [self showPauseViewAnim:[_playerView rate]];
    [_playerView updatePlayerState];
}

- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    } else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}



//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"likeSelect2.png"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
}

#pragma mark - initData
- (void)initData:(Aweme *)aweme {
    _aweme = aweme;

    // 设置昵称
    [_nickName setText:[NSString stringWithFormat:@"@%@", aweme.author.nickname]];

    // 设置视频描述
    [_desc setText:aweme.desc];

    // 设置音乐信息
    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", aweme.music.title, aweme.music.author]];

    // 设置点赞数、评论数、分享数
    [_favoriteNum setText:[NSString formatCount:aweme.statistics.digg_count]];
    [_commentNum setText:[NSString formatCount:aweme.statistics.comment_count]];
    [_shareNum setText:[NSString formatCount:aweme.statistics.share_count]];

    // 加载音乐封面
    __weak __typeof(self) wself = self;
    NSLog(@"imageURL:%@",aweme.author.avatar_url);
    [_musicAlum.album sd_setImageWithURL:[NSURL URLWithString:aweme.music.cover_url]
                       placeholderImage:nil
                                 options:SDWebImageProgressiveDownload
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            //wself.musicAlum.album.image = [image drawCircleImage]; // 假设 drawCircleImage 是自定义的圆形裁剪方法
        }
    }];

    // 加载用户头像
    [_avatar sd_setImageWithURL:[NSURL URLWithString:aweme.author.avatar_url]
              placeholderImage:nil
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            //wself.avatar.image = [image drawCircleImage]; // 假设 drawCircleImage 是自定义的圆形裁剪方法
        }
    }];

}

#pragma mark - Comment Button Action

- (void)commentTapAction {
    if ([self.delegate respondsToSelector:@selector(videoCellDidTapComment:)]) {
        [self.delegate videoCellDidTapComment:self];
    }
}

#pragma mark - AVPlayerUpdateDelegate

//播放进度更新
//- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
//    NSLog(@"当前播放进度: %.2f/%.2f", current, total);
//}

// 播放器状态更新
- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            // 播放器状态未知
            break;
        case AVPlayerItemStatusReadyToPlay:
            // 播放器准备就绪
            _isPlayerReady = YES;
            if (_onPlayerReady) {
                _onPlayerReady(); // 回调播放器准备就绪
            }
            break;
        case AVPlayerItemStatusFailed:
            // 播放器加载失败
            NSLog(@"播放器加载失败");
            break;
        default:
            break;
    }
}



//-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
//    switch (status) {
//        case AVPlayerItemStatusUnknown:
//           // [self startLoadingPlayItemAnim:YES];
//            break;
//        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnim:NO];
//            _isPlayerReady = YES;
//            [_musicAlum startAnimation:_aweme.rate];
//            if(_onPlayerReady) {
//                _onPlayerReady();
//            }
//            break;
//        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnim:NO];
//            [UIWindow showTips:@"加载失败"];
//            break;
//        default:
//            break;
//    }
//}

@end

//- (void)initData:(Aweme *)aweme {
//    _aweme = aweme;
//
//    // 设置昵称
//    [_nickName setText:[NSString stringWithFormat:@"@%@", aweme.author.nickname]];
//
//    // 设置视频描述
//    [_desc setText:aweme.desc];
//
//    // 设置音乐信息
//    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", aweme.music.title, aweme.music.author]];
//
//    // 设置点赞数、评论数、分享数
//    [_favoriteNum setText:[NSString formatCount:aweme.statistics.digg_count]];
//    [_commentNum setText:[NSString formatCount:aweme.statistics.comment_count]];
//    [_shareNum setText:[NSString formatCount:aweme.statistics.share_count]];
//
//    // 加载音乐封面
//    __weak __typeof(self) wself = self;
//
//    [_musicAlum.album sd_setImageWithURL:[NSURL URLWithString:aweme.music.cover_thumb.url_list.firstObject]
//                       placeholderImage:nil
//                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!error && image) {
//            //wself.musicAlum.album.image = [image drawCircleImage]; // 假设 drawCircleImage 是自定义的圆形裁剪方法
//        }
//    }];
//
//    // 加载用户头像
//    [_avatar sd_setImageWithURL:[NSURL URLWithString:aweme.author.avatar_thumb.url_list.firstObject]
//              placeholderImage:nil
//                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!error && image) {
//            //wself.avatar.image = [image drawCircleImage]; // 假设 drawCircleImage 是自定义的圆形裁剪方法
//        }
//    }];
//
//}
