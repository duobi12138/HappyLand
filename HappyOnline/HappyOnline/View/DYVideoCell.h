//
//  DYVideoCell.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import <UIKit/UIKit.h>
#import "FocusView.h"
#import "FavoriteView.h"
#import "CircleTextView.h"
#import "MusciAlbumView.h"
#import "CircleTextView.h"
#import "Aweme.h"
#import "WebCacheHelper.h"

@class DYVideoCell;

@protocol DYVideoCellDelegate <NSObject>
- (void)videoCellDidTapComment:(DYVideoCell *)cell;
@end

typedef void (^OnPlayerReady)(void);

@class AVPlayerView;

@interface DYVideoCell : UITableViewCell

@property (nonatomic, weak) id<DYVideoCellDelegate> delegate;
@property (nonatomic, strong) WebCacheHelper *cacheHelper; // 添加缓存帮助类


@property (nonatomic, strong) Aweme            *aweme;


@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;
//按钮
@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;

@property (nonatomic, strong) FocusView        *focus;
@property (nonatomic, strong) UIImageView      *avatar;
@property (nonatomic, strong) MusciAlbumView   *musicAlum;

@property (nonatomic, strong) FavoriteView     *favorite;

@property (nonatomic, strong) CircleTextView   *musicName;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;
@property (nonatomic ,strong) UIImageView      *musicIcon;

@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;

//视图
@property (nonatomic, strong) UIView           *container;

//暂停和双击点赞
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, strong) UIImageView              *pauseIcon;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@property (nonatomic, strong) UIView                   *playerStatusBar;

//进度条
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) CGFloat totalDuration;

- (void)initData:(Aweme *)aweme;
- (void)play;  // 播放
- (void)pause; // 暂停
- (void)replay; // 重新播放
- (void)setVideoURL:(NSURL *)url ;
@end


