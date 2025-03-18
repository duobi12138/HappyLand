//
//  VideoCell.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "VideoCell.h"
#import "Masonry/Masonry.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}

//- (void)setupUI {
//    // 1. 视频封面
//    self.coverImageView = [[UIImageView alloc] init];
//    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.coverImageView.clipsToBounds = YES;
//    self.coverImageView.backgroundColor = [UIColor lightGrayColor]; // 默认背景色
//    [self.contentView addSubview:self.coverImageView];
//
//    // 2. 视频标题
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.titleLabel];
//
//    // 使用 Masonry 布局
//    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.contentView);
//        make.height.mas_equalTo(20);
//    }];
//}
//
//- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title {
//    // 加载封面图片（使用 SDWebImage 或 AFNetworking）
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    self.titleLabel.text = title;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
                                              green:arc4random() % 255 / 255.0
                                               blue:arc4random() % 255 / 255.0
                                              alpha:1];
    }
    return self;
}


- (void)configureWithImageURL:(nonnull NSString *)imageURL title:(nonnull NSString *)title {
    
}

@end
