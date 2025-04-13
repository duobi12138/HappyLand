//
//  DYVideoController.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import <UIKit/UIKit.h>
#import "Aweme.h"
#import "DYVideoCell.h"
#import "XXVideoCommentController.h"

@class AVPlayerView;


@interface DYVideoController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, DYVideoCellDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex; // 当前播放的视频索引
@property (nonatomic, assign) BOOL isCurPlayerPause; // 当前视频是否暂停
@property (nonatomic, strong) NSMutableArray<Aweme *> *data; // 存储Aweme对象
@property (nonatomic, strong) NSMutableArray *awemeIdList; // 存储视频ID列表
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@end


