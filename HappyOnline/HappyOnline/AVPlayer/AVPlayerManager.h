//
//  AVPlayerManager.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerManager : NSObject

@property (nonatomic, strong) NSMutableArray<AVPlayer *> *playerArray;

+ (AVPlayerManager *)shareManager;
+ (void)setAudioMode;
- (void)play:(AVPlayer *)player;
- (void)pause:(AVPlayer *)player;
- (void)pauseAll;
- (void)replay:(AVPlayer *)player;
- (void)removeAllPlayers;

@end

NS_ASSUME_NONNULL_END
