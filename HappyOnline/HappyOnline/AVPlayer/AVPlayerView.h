//
//  AVPlayerView.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WebCacheHelper.h"

//自定义Delegate，用于进度、播放状态更新回调
@protocol AVPlayerUpadteDelegate

@required
//播放进度更新回调方法
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total;

//播放状态更新回调方法
-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status;

@end

NS_ASSUME_NONNULL_BEGIN

//封装了AVPlayerLayer的自定义View
@interface AVPlayerView : UIView<NSURLSessionTaskDelegate,NSURLSessionDataDelegate,AVAssetResourceLoaderDelegate>

@property(nonatomic, weak) id<AVPlayerUpadteDelegate> delegate;

@property (nonatomic, strong) WebCacheHelper *cacheHelper;
// 添加属性记录观察状态
@property (nonatomic, assign) BOOL hasAddedLoadedTimeRangesObserver;

@property (nonatomic, assign) BOOL shouldObserveLoadedTimeRanges; // 是否监听缓冲进度
@property (nonatomic, strong) NSString *tempFilePath; // 存储临时文件路径


@property (nonatomic ,strong) NSURL                *sourceURL;              //视频路径
@property (nonatomic ,strong) NSString             *sourceScheme;           //路径Scheme
@property (nonatomic ,strong) AVURLAsset           *urlAsset;               //视频资源
@property (nonatomic ,strong) AVPlayerItem         *playerItem;             //视频资源载体
@property (nonatomic ,strong) AVPlayer             *player;                 //视频播放器
@property (nonatomic ,strong) AVPlayerLayer        *playerLayer;            //视频播放器图形化载体
@property (nonatomic ,strong) id                   timeObserver;            //视频播放器周期性调用的观察者

@property (nonatomic, strong) NSMutableData        *data;                   //视频缓冲数据
@property (nonatomic, copy) NSString               *mimeType;               //资源格式
@property (nonatomic, assign) long long            expectedContentLength;   //资源大小
@property (nonatomic, strong) NSMutableArray       *pendingRequests;        //存储AVAssetResourceLoadingRequest的数组

@property (nonatomic, copy) NSString               *cacheFileKey;           //缓存文件key值
@property (nonatomic, strong) NSOperation          *queryCacheOperation;    //查找本地视频缓存数据的NSOperation
@property (nonatomic, strong) dispatch_queue_t     cancelLoadingQueue;

//@property (nonatomic, strong) WebCombineOperation  *combineOperation;

@property (nonatomic, assign) BOOL                 retried;

//设置播放路径
-(void)setPlayerWithUrl:(NSString *)url;

-(void)cancelLoading;

//-(void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground;

//更新AVPlayer状态，播放变暂停，暂停变播放
-(void)updatePlayerState;

-(void)play;

-(void)pause;

-(void)replay;

-(CGFloat)rate;

-(void)retry;

- (void)seekToTime:(CGFloat)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end

NS_ASSUME_NONNULL_END
