//
//  CircleTextView.h
//  短视频app仿写
//
//  Created by 刘原甫 on 2025/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleTextView : UIView

@property(nonatomic, assign) NSString    *text;
@property(nonatomic, strong) UIColor     *textColor;
@property(nonatomic, strong) UIFont      *font;

@property(nonatomic, strong) CATextLayer   *textLayer;
@property(nonatomic, strong) CAShapeLayer  *maskLayer;
@property(nonatomic, assign) CGFloat       textSeparateWidth;
@property(nonatomic, assign) CGFloat       textWidth;
@property(nonatomic, assign) CGFloat       textHeight;
@property(nonatomic, assign) CGRect        textLayerFrame;
@property(nonatomic, assign) CGFloat       translationX;

@end

NS_ASSUME_NONNULL_END
