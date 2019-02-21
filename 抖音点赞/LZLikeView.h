//
//  LZLikeView.h
//  抖音点赞
//
//  Created by Albin on 2019/2/21.
//  Copyright © 2019 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZLikeView : UIView

//点赞前图片
@property (nonatomic, strong) UIImageView *likeBefore;
//点赞后图片
@property (nonatomic, strong) UIImageView *likeAfter;
//点赞时长
@property (nonatomic, assign) CGFloat     likeDuration;
//点赞按钮填充颜色
@property (nonatomic, strong) UIColor     *zanFillColor;

@end

NS_ASSUME_NONNULL_END
