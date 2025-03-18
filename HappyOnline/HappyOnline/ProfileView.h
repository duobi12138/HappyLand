//
//  ProfileView.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *followsLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *videos; // 视频数据

- (void)fetchProfileData; // 获取个人数据
- (void)fetchVideosData;  // 获取视频数据

@end

NS_ASSUME_NONNULL_END
