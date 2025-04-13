//
//  ProfileViewController.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;//个人信息区域
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, assign) CGFloat segmentControlOffsetY; // 分栏控件的初始 Y 坐标
@property (nonatomic, strong) NSArray<NSURL *> *videoURLs; // 视频 URL 数组
@property (nonatomic, strong) NSArray *favoritesData; // 我的喜欢数据
@property (nonatomic, assign) Boolean *isCollectionViewAtBottom;
@property (nonatomic, strong) UILabel *endIndicator;

@end

NS_ASSUME_NONNULL_END
