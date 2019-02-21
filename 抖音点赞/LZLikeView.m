//
//  LZLikeView.m
//  抖音点赞
//
//  Created by Albin on 2019/2/21.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "LZLikeView.h"

#define CCFavoriteViewLikeBeforeTag 1 //点赞
#define CCFavoriteViewLikeAfterTag  2 //取消点赞

@interface LZLikeView()

@property (nonatomic ,assign) CGFloat length;

@end

@implementation LZLikeView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        _likeBefore = [[UIImageView alloc]initWithFrame:self.bounds];
        _likeBefore.contentMode = UIViewContentModeCenter;
        _likeBefore.image = [UIImage imageNamed:@"icon_home_like_before"];
        _likeBefore.userInteractionEnabled = YES;
        _likeBefore.tag = CCFavoriteViewLikeBeforeTag;
        [_likeBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeBefore];
        
        _likeAfter = [[UIImageView alloc]initWithFrame:self.bounds];
        _likeAfter.contentMode = UIViewContentModeCenter;
        _likeAfter.image = [UIImage imageNamed:@"icon_home_like_after"];
        _likeAfter.userInteractionEnabled = YES;
        _likeAfter.tag = CCFavoriteViewLikeAfterTag;
        [_likeAfter setHidden:YES];
        [_likeAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeAfter];
        
        _length = 30;
    }
    return self;
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case CCFavoriteViewLikeBeforeTag: {
            //开始动画(点赞)
            [self startLikeAnim:YES];
            break;
        }
        case CCFavoriteViewLikeAfterTag: {
            //开始动画(取消点赞)
            [self startLikeAnim:NO];
            break;
        }
    }
}

-(void)startLikeAnim:(BOOL)isLike {
    
    _likeBefore.userInteractionEnabled = NO;
    _likeAfter.userInteractionEnabled = NO;
    
    
    if(isLike) {
        
        CGFloat duration = self.likeDuration > 0? self.likeDuration :0.5f;
        
        for(int i=0;i<6;i++) {
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.position = _likeBefore.center;
            layer.fillColor = self.zanFillColor == nil?[UIColor redColor].CGColor: self.zanFillColor.CGColor;
            
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            [startPath moveToPoint:CGPointMake(-2, -_length)];
            [startPath addLineToPoint:CGPointMake(2, -_length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
            layer.path = startPath.CGPath;
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            group.fillMode = kCAFillModeForwards;
            group.duration = duration;
            
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            scaleAnim.duration = duration * 0.2f;
            
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            [endPath moveToPoint:CGPointMake(-2, -_length)];
            [endPath addLineToPoint:CGPointMake(2, -_length)];
            [endPath addLineToPoint:CGPointMake(0, -_length)];
            
            
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnim.fromValue = (__bridge id)layer.path;
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            [group setAnimations:@[scaleAnim, pathAnim]];
            [layer addAnimation:group forKey:nil];
        }
        [self createCircleAnimation];
        [_likeAfter setHidden:NO];
        _likeAfter.alpha = 0.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.5f, 0.5f);
        [UIView animateWithDuration:0.4f
                              delay:0.2f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.8f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeBefore.alpha = 0.0f;
                             self.likeAfter.alpha = 1.0f;
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             self.likeBefore.alpha = 1.0f;
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }else {
        _likeAfter.alpha = 1.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        [UIView animateWithDuration:0.35f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.likeAfter setHidden:YES];
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }
}

- (void)createCircleAnimation{
    //创建背景
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.position = _likeBefore.center;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = _zanFillColor?_zanFillColor.CGColor:[UIColor redColor].CGColor;
    layer.lineWidth = 1;
    
    //设置笔画路径
    UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:_length startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2 clockwise:YES];
    layer.path = bPath.CGPath;
    [self.layer addSublayer:layer];
    
    //使用动画组来解决圆圈从小到大 --> 消失
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;//必须-->group.removedOnCompletion = NO;才生效
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = _likeDuration*0.8;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.duration = _likeDuration*0.8*0.8;
    scaleAnim.fromValue = @(0.0);
    scaleAnim.toValue = @(1.0);
    
    CABasicAnimation *widthStarAnim = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthStarAnim.beginTime = 0;
    widthStarAnim.duration = _likeDuration*0.8*0.8;
    widthStarAnim.fromValue = @(1);
    widthStarAnim.toValue = @(3);
    
    CABasicAnimation *widthEndAnim = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthEndAnim.beginTime = _likeDuration*0.8*0.8;
    widthEndAnim.duration = _likeDuration*0.8*0.2;
    widthEndAnim.fromValue = @(3);
    widthEndAnim.toValue = @(0);
    
    [group setAnimations:@[scaleAnim,widthStarAnim,widthEndAnim]];
    [layer addAnimation:group forKey:nil];
}


@end
