//
//  XXCommentCell.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <UIKit/UIKit.h>

@class CommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface XXCommentCell : UITableViewCell

@property (nonatomic, strong) CommentModel      *comment;
@property (nonatomic, strong) UIImageView       *avatarImageView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *contentLabel;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UIButton          *likeButton;
@property (nonatomic, strong) UIImageView       *commentImageView;


+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
