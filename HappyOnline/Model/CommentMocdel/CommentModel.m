//
//  CommentModel.m
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import "CommentModel.h"

@implementation CommentModel

+ (instancetype)commentWithDict:(NSDictionary *)dict {
    CommentModel *model = [[CommentModel alloc] init];
    model.cid = dict[@"cid"] ?: @"";
    model.text = dict[@"text"] ?: @"";
    model.createTime = [dict[@"create_time"] integerValue];
    model.diggCount = [dict[@"digg_count"] integerValue];
    model.replyCommentTotal = [dict[@"reply_comment_total"] integerValue];
    model.level = [dict[@"level"] integerValue];
    
    // 用户信息
    if (dict[@"user"]) {
        model.user = [CommentUserModel userWithDict:dict[@"user"]];
    }
    
    // 图片列表
    if ([dict[@"image_list"] isKindOfClass:[NSArray class]]) {
        model.imageList = dict[@"image_list"];
    }
    
    return model;
}

- (CGFloat)cellHeight {
    // 基础高度
    CGFloat height = 80;
    
    // 计算文本高度
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - 80;
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                             context:nil].size;
    height += textSize.height;
    
    // 如果有图片，增加图片高度
    if (self.imageList.count > 0) {
        height += 100; // 图片固定高度
    }
    
    return height;
}

@end
