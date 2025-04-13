//
//  XXVideoCommentController.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/25.
//

#import <UIKit/UIKit.h>
#import "CommentViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface XXVideoCommentController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CommentViewModel *viewModel;
@property (nonatomic, copy) NSString *awemeId; // 视频ID
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *container; // 添加这行

@end

NS_ASSUME_NONNULL_END
