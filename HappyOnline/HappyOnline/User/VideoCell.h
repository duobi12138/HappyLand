//
//  VideoCell.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) AVPlayer *player; // 视频播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer; // 视频播放器图层
@property (nonatomic, strong) NSURL *videoURL; // 视频 URL

- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
