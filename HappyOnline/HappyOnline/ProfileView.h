//
//  ProfileView.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import <UIKit/UIKit.h>
#import "SegmentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *followsLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *videos; // 视频数据
@property (nonatomic, strong) SegmentView *segmentView;
@property (nonatomic, assign) BOOL isSegmentViewPinned;

//@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)fetchProfileData; // 获取个人数据
- (void)fetchVideosData;  // 获取视频数据

@end

NS_ASSUME_NONNULL_END
