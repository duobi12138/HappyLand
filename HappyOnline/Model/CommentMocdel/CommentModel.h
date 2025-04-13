//
//  CommentModel.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentUserModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CommentModel : NSObject

@property (nonatomic, copy) NSString            *cid;
@property (nonatomic, copy) NSString            *text;
@property (nonatomic, assign) NSInteger         createTime;
@property (nonatomic, assign) NSInteger         diggCount;
@property (nonatomic, strong) CommentUserModel  *user;
@property (nonatomic, assign) NSInteger         replyCommentTotal;
@property (nonatomic, strong) NSArray           *imageList;
@property (nonatomic, assign) NSInteger         level; //评论层级

// 解析方法
+ (instancetype)commentWithDict:(NSDictionary *)dict;

// 计算cell高度
- (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
