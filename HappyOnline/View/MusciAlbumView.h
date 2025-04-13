//
//  MusciAlbumView.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusciAlbumView : UIView

@property (nonatomic, strong) UIImageView      *album;
@property (nonatomic, strong) UIView                        *albumContainer;
@property (nonatomic, strong) NSMutableArray<CALayer *>     *noteLayers;

- (void)startAnimation:(CGFloat)rate;
- (void)resetView;

@end


NS_ASSUME_NONNULL_END
