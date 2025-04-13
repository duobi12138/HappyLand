//
//  XXCommentCell.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "XXCommentCell.h"
#import "CommentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@implementation XXCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void) setupUI {
    //UI初始化
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.cornerRadius = 20;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
       

    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"likeSelect2.png"] forState:UIControlStateSelected];
    [_likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeButton];
       
    _commentImageView = [[UIImageView alloc] init];
    _commentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _commentImageView.layer.cornerRadius = 4;
    _commentImageView.layer.masksToBounds = YES;
    _commentImageView.hidden = YES;
    [self.contentView addSubview:_commentImageView];
       
    [self setupConstraints];
}

//- (void) setupConstraints {
//    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(self.contentView).offset(10);
//            make.width.height.mas_equalTo(40);
//        }];
//        
//        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_avatarImageView);
//            make.left.equalTo(_avatarImageView.mas_right).offset(10);
//            make.right.equalTo(self.contentView).offset(-10);
//        }];
//        
//        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
//            make.left.equalTo(_nameLabel);
//            make.right.equalTo(self.contentView).offset(-10);
//        }];
//        
//        [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_contentLabel.mas_bottom).offset(10);
//            make.left.equalTo(_nameLabel);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(80);
//        }];
//        
//        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_commentImageView.mas_bottom).offset(10);
//            make.left.equalTo(_nameLabel);
//            make.bottom.equalTo(self.contentView).offset(-10);
//        }];
//        
//        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_timeLabel);
//            make.right.equalTo(self.contentView).offset(-10);
//            make.width.height.mas_equalTo(30);
//        }];
//}

//报错后修改
- (void)setupConstraints {
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    // 修改图片约束，不固定高度
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(10);
        make.left.equalTo(_nameLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(80).priorityHigh(); // 设置为高优先级但不是必须
    }];
    
    // 关键修改：timeLabel的顶部约束
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentImageView.mas_bottom).offset(10).priorityHigh();
        make.top.equalTo(_contentLabel.mas_bottom).offset(10).priorityMedium(); // 当图片隐藏时的备用约束
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.height.mas_equalTo(30);
    }];
}

-(void)setComment:(CommentModel *)comment {
    _comment = comment;
    
    if (comment.user.avatarUrl) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    } else {
        _avatarImageView.image = [UIImage imageNamed:@"defaul_avatar"];
    }
    
    _nameLabel.text = comment.user.nickname;
    
    _contentLabel.text = comment.text;
    
    _timeLabel.text = [self timeStringFromTimestamp:comment.createTime];
    
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)comment.diggCount] forState:UIControlStateNormal];
    
//    if (comment.imageList.count > 0) {
//        _commentImageView.hidden = NO;
//        NSDictionary *imageDict = comment.imageList[0];
//        NSString *imageUrl = imageDict[@"origin_url"][@"url_list"][0];
//        [_commentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    } else {
//        _commentImageView.hidden = YES;
//    }
    
    if (comment.imageList.count > 0) {
           _commentImageView.hidden = NO;
            NSDictionary *imageDict = comment.imageList[0];
            NSString *imageUrl = imageDict[@"origin_url"][@"url_list"][0];
            [_commentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
           // 激活图片视图的约束
           [_commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(80);
           }];
       } else {
           _commentImageView.hidden = YES;
           // 当图片隐藏时，设置高度为0
           [_commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(0);
           }];
       }
       
       // 告诉cell更新布局
       [self.contentView layoutIfNeeded];
}

- (NSString *)timeStringFromTimestamp:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
    
}

- (void)likeButtonClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSInteger likeCount = self.comment.diggCount;
    if (sender.isSelected) {
        likeCount++;
    } else {
        likeCount--;
    }
    [sender setTitle:[NSString stringWithFormat:@"%ld", (long)likeCount] forState:UIControlStateNormal];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
@end
