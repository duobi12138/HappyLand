//
//  AVPlayerView.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import "AVPlayerView.h"
#import "AVPlayerManager.h"
#import "WebCache.h"

@implementation AVPlayerView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        _cacheHelper = [WebCacheHelper sharedHelper];

        
        _pendingRequests = [NSMutableArray array];
        
        _player = [AVPlayer new];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        /**
            videoGravity //视频播放时的拉伸方式
            param:
                AVLayerVideoGravityResizeAspect //等比例填充，直到一个维度到达区域边界。部分机型有黑边
                AVLayerVideoGravityResizeAspectFill //等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
                AVLayerVideoGravityResize //非均匀模式。两个维度完全填充至整个视图区域。会变形
        */
        
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerLayer.shouldRasterize = YES;

        [self.layer addSublayer:_playerLayer];
        
        //初始化取消视频加载的队列
        _cancelLoadingQueue = dispatch_queue_create("com.start.cancelloadingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    [CATransaction commit];
}

//-(void)setPlayerWithUrl:(NSString *)url {
//    self.sourceURL = [NSURL URLWithString:url];
//    
//    __weak typeof(self) weakSelf = self;
//        [self.cacheHelper queryDataFromCacheWithURL:self.sourceURL completion:^(NSData * _Nullable data) {
//            if (data) {
//                // 缓存命中
//                NSLog(@"AVPlayerView命中");
//                [weakSelf setupPlayerWithCachedData:data];
//            } else {
//                // 缓存未命中，从网络加载
//                NSLog(@"AVPlayerView未命中");
//
//                [weakSelf setupPlayerWithRemoteURL];
//            }
//        }];
//    
////    self.urlAsset = [AVURLAsset URLAssetWithURL:self.sourceURL options:nil];
////    
////    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
////    
////    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
////    
////    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
////    self.playerLayer.player = self.player;
////    
////    [self addProgressObserver];
//}

//poe
- (void)setPlayerWithUrl:(NSString *)url {
    self.sourceURL = [NSURL URLWithString:url];

    NSLog(@"soueceURL在AVPlaryerView：%@",self.sourceURL);
    
    __weak typeof(self) weakSelf = self;
    [self.cacheHelper queryDataFromCacheWithURL:self.sourceURL completion:^(NSData * _Nullable data) {
        if (data) {
            // 缓存命中
            NSLog(@"AVPlayerView缓存命中");
            NSLog(@"AVPlayerView的data:%@",data);
            [weakSelf setupPlayerWithCachedData:data];
        } else {
            // 缓存未命中，从网络加载
            NSLog(@"AVPlayerView缓存未未命中");
            [weakSelf setupPlayerWithRemoteURL];
            NSLog(@"AVPlayerView缓存未未命中");
        }
    }];
}


// 使用缓存数据设置播放器
- (void)setupPlayerWithCachedData:(NSData *)data {
    NSLog(@"使用缓存数据设置播放器");
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_video.mp4"];
    [data writeToFile:tempPath atomically:YES];
    NSURL *tempURL = [NSURL fileURLWithPath:tempPath];

    self.urlAsset = [AVURLAsset URLAssetWithURL:tempURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    
    // 确保移除旧的观察者
    //[self safeRemoveObservers];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer.player = self.player;
    
    [self addProgressObserver];
}

// 从网络URL设置播放器
- (void)setupPlayerWithRemoteURL {
    //[self safeRemoveObservers]; // 移除旧观察者
    NSLog(@"网络URL播放播放器");
    self.urlAsset = [AVURLAsset URLAssetWithURL:self.sourceURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer.player = self.player;

    [self addProgressObserver];
}

//poe结束

// 使用缓存数据设置播放器yuanben1
//- (void)setupPlayerWithCachedData:(NSData *)data {
//    // 创建临时文件路径
//    NSLog(@"使用缓存数据设置播放器");
//    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_video.mp4"];
//    [data writeToFile:tempPath atomically:YES];
//    NSURL *tempURL = [NSURL fileURLWithPath:tempPath];
//    
//    self.urlAsset = [AVURLAsset URLAssetWithURL:tempURL options:nil];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
//    
//    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
//    self.playerLayer.player = self.player;
//    
//    [self addProgressObserver];
//}

// 从网络URL设置播放器old1
//- (void)setupPlayerWithRemoteURL {
//    // 先移除旧观察者
//    [self safeRemoveLoadedTimeRangesObserver];
//    
//    self.urlAsset = [AVURLAsset URLAssetWithURL:self.sourceURL options:nil];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
//    
//    // 监听缓冲进度（仅对远程URL）
//    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    self.hasAddedLoadedTimeRangesObserver = YES;
//    
//    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
//    self.playerLayer.player = self.player;
//    
//    [self addProgressObserver];
//}

//yuanben1
//- (void)setupPlayerWithRemoteURL {
//    // 先移除旧观察者
//    [self safeRemoveObservers];
//    
//    self.urlAsset = [AVURLAsset URLAssetWithURL:self.sourceURL options:nil];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//    
//    // 必须监听的属性
//    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    
//    // 按需监听缓冲进度
//    if (self.shouldObserveLoadedTimeRanges) {
//        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    }
//    
//    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
//    self.playerLayer.player = self.player;
//    
//    [self addProgressObserver];
//}


// 安全移除所有观察者poe
//- (void)safeRemoveObservers {
//    if (self.playerItem) {
//        @try {
//            [self.playerItem removeObserver:self forKeyPath:@"status"];
//        } @catch (NSException *exception) {
//            NSLog(@"移除status观察者异常: %@", exception);
//        }
//        
//        @try {
//            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//        } @catch (NSException *exception) {
//            NSLog(@"移除loadedTimeRanges观察者异常: %@", exception);
//        }
//    }
//}


// 安全的移除方法old1
- (void)safeRemoveLoadedTimeRangesObserver {
    if (self.hasAddedLoadedTimeRangesObserver && self.playerItem) {
        @try {
            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        } @catch (NSException *exception) {
            NSLog(@"移除观察者异常: %@", exception);
        }
        self.hasAddedLoadedTimeRangesObserver = NO;
    }
}

//- (void)safeRemoveObservers {
//    if (self.playerItem) {
//        @try {
//            [self.playerItem removeObserver:self forKeyPath:@"status"];
//        } @catch (NSException *exception) {
//            NSLog(@"移除status观察者异常: %@", exception);
//        }
//        
//        @try {
//            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//        } @catch (NSException *exception) {
//            NSLog(@"移除loadedTimeRanges观察者异常: %@", exception);
//        }
//    }
//}

//取消播放，无缓存
//- (void)cancelLoading {
//    //暂停视频播放
//    [self pause];
//    
//    //隐藏playerLayer
//    [_playerLayer setHidden:YES];
//    
//    _player = nil;
//    [_playerItem removeObserver:self forKeyPath:@"status"];
//    _playerItem = nil;
//    _playerLayer.player = nil;
//    
//    __weak __typeof(self) wself = self;
//    dispatch_async(self.cancelLoadingQueue, ^{
//        //取消AVURLAsset加载
//        [wself.urlAsset cancelLoading];
//        wself.data = nil;
//        
//        //结束所有视频数据加载请求
//        [wself.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
//            if (![loadingRequest isFinished]) {
//                [loadingRequest finishLoading];
//            }
//        }];
//        [wself.pendingRequests removeAllObjects];
//    });
//    
//    _retried = NO;
//}

//更新AVPlayer状态，当前播放则暂停，当前暂停则播放
-(void)updatePlayerState {
    if(_player.rate == 0) {
        [self play];
    }else {
        [self pause];
    }
}

//播放
-(void)play {
    [[AVPlayerManager shareManager] play:_player];
}

//暂停
-(void)pause {
    [[AVPlayerManager shareManager] pause:_player];
}

//重新播放
-(void)replay {
    [[AVPlayerManager shareManager] replay:_player];
}

-(void)retry {
    [self cancelLoading]; // 取消当前加载任务
    [self setPlayerWithUrl:_sourceURL.absoluteString]; // 重新初始化播放器
    _retried = YES; // 标记已重试
}

//播放速度
-(CGFloat)rate {
    return [_player rate];
}


- (void)seekToTime:(CGFloat)time completionHandler:(void (^)(BOOL finished))completionHandler {
    CMTime targetTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    [self.player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}




#pragma kvo

// 给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
- (void)addProgressObserver {
    __weak __typeof(self) weakSelf = self;
    // 将回调间隔改为 0.1 秒
    CMTime interval = CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC); // 每 0.1 秒回调一次
    _timeObserver = [_player addPeriodicTimeObserverForInterval:interval
                                                         queue:dispatch_get_main_queue()
                                                    usingBlock:^(CMTime time) {
        if (weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            // 获取当前播放时间
            float current = CMTimeGetSeconds(time);
            // 获取视频播放总时间
            float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
            // 重新播放视频
            if (total == current) {
                [weakSelf replay];
            }
            // 更新视频播放进度方法回调
            if (weakSelf.delegate) {
                [weakSelf.delegate onProgressUpdate:current total:total];
            }
        }
    }];
}

// 响应KVO值变化的方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    //AVPlayerItem.status
//    if([keyPath isEqualToString:@"status"]) {
//        if(_playerItem.status == AVPlayerItemStatusFailed) {
//            if(!_retried) {
//                [self retry];
//            }
//        }
//        //视频源装备完毕，则显示playerLayer
//        if(_playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            [self.playerLayer setHidden:NO];
//        }
//        //视频播放状体更新方法回调
//        if(_delegate) {
//            [_delegate onPlayItemStatusUpdate:_playerItem.status];
//        }
//    }else {
//        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

//加入缓存后的kvo，处理缓冲完成后的缓存存储
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (_playerItem.status == AVPlayerItemStatusFailed) {
            if (!_retried) {
                [self retry];
            }
        }
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playerLayer setHidden:NO];
        }
        if (_delegate) {
            [_delegate onPlayItemStatusUpdate:_playerItem.status];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 当缓冲足够多时，将视频数据缓存
        NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffered = startSeconds + durationSeconds;
        
        // 当缓冲超过10秒或缓冲完成时，尝试缓存
        CMTime duration = _playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        if (totalBuffered > 10 || totalBuffered >= totalDuration) {
            [self cacheCurrentVideoIfNeeded];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 缓存当前视频
- (void)cacheCurrentVideoIfNeeded {
    
    NSLog(@"进入AVPView的缓存");
    if (!self.sourceURL || self.sourceURL.isFileURL) {
        return; // 不缓存本地文件
    }
    NSLog(@"不缓存本地文件经过");
    // 检查是否已经缓存过
    NSString *key = [self.cacheHelper cacheKeyForURL:self.sourceURL];
    NSData *cachedData = [[WebCache sharedCache] dataFromCacheForKey:key];
    if (cachedData) {
        return; // 已经缓存过
    }
    NSLog(@"以及检查是否缓存过");

    // 获取AVAsset的URL
    AVURLAsset *urlAsset = (AVURLAsset *)self.playerItem.asset;
    if (![urlAsset isKindOfClass:[AVURLAsset class]]) {
        return;
    }

    // 异步读取数据并缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"读取并缓存缓存本地文件");
        NSData *videoData = [NSData dataWithContentsOfURL:urlAsset.URL];
        if (videoData) {
            [self.cacheHelper storeData:videoData forURL:self.sourceURL];
        }
    });
}

- (void)cancelLoading {
    [self pause];
    [_playerLayer setHidden:YES];
    
    _player = nil;
    
    // 安全移除所有观察者
    if (_playerItem) {
        @try {
            [_playerItem removeObserver:self forKeyPath:@"status"];
        } @catch (NSException *exception) {
            NSLog(@"移除status观察者异常: %@", exception);
        }
        
        [self safeRemoveLoadedTimeRangesObserver];
    }
    
    _playerItem = nil;
    _playerLayer.player = nil;
    
    __weak __typeof(self) wself = self;
    dispatch_async(self.cancelLoadingQueue, ^{
        [wself.urlAsset cancelLoading];
        wself.data = nil;
        
        [wself.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
            if (![loadingRequest isFinished]) {
                [loadingRequest finishLoading];
            }
        }];
        [wself.pendingRequests removeAllObjects];
    });
    
    _retried = NO;
}


- (void)dealloc {
    [self cancelLoading];
    [_player removeTimeObserver:_timeObserver];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)addProgressObserver{
//    __weak __typeof(self) weakSelf = self;
//    //AVPlayer添加周期性回调观察者，一秒调用一次block，用于更新视频播放进度
//    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            //获取当前播放时间
//            float current = CMTimeGetSeconds(time);
//            //获取视频播放总时间
//            float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
//            //重新播放视频
//            if(total == current) {
//                [weakSelf replay];
//            }
//            //更新视频播放进度方法回调
//            if(weakSelf.delegate) {
//                [weakSelf.delegate onProgressUpdate:current total:total];
//            }
//        }
//    }];
//}

@end
