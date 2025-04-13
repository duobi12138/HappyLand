//
//  FavoriteView.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/17.
//

#import <UIKit/UIKit.h>

@class FavoriteView;

@protocol FavoriteViewDelegate <NSObject>
- (void)favoriteView:(FavoriteView *)favoriteView didTapFavorite:(BOOL)isFavorite;
@end

@interface FavoriteView : UIView

@property (nonatomic, weak) id<FavoriteViewDelegate> delegate;
@property (nonatomic, strong) UIImageView       *favoriteBefore;
@property (nonatomic, strong) UIImageView       *favoriteAfter;
@property (nonatomic, assign) BOOL isFavorite; // 是否选中

- (void)resetView;

@end

