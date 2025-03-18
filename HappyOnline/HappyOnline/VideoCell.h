//
//  VideoCell.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
