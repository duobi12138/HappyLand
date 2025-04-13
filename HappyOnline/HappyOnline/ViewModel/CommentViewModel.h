//
//  CommentViewModel.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CommentRequestSuccess)(NSArray<CommentModel *> *comments, BOOL hasMore);
typedef void (^CommentRequestFailure)(NSError *error);

@interface CommentViewModel : NSObject

@property (nonatomic, strong) NSArray<CommentModel *> *comments;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSInteger cursor;
@property (nonatomic, copy) NSString *awemeId;

// 加载评论数据
- (void)loadCommentsWithSuccess:(CommentRequestSuccess)success failure:(CommentRequestFailure)failure;

// 加载更多评论
- (void)loadMoreCommentsWithSuccess:(CommentRequestSuccess)success failure:(CommentRequestFailure)failure;
@end

NS_ASSUME_NONNULL_END
