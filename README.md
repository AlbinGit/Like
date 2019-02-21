# 抖音点赞

抖音最近越来越火，是新媒体的代表，最新我研究了一下抖音点赞的动画效果，顺便也给大家分享一下。


![like.gif](https://upload-images.jianshu.io/upload_images/3890613-4d61f32ddf01c53b.gif?imageMogr2/auto-orient/strip)


我们仔细观察会发现点赞的时候会发散出6个红色的三角形，所以我们可以利用贝斯阿尔曲线画出来，直接上代码：   

CAShapeLayer *layer = [[CAShapeLayer alloc]init];
layer.position = _likeBefore.center;
layer.fillColor = [UIColor redColor].CGColor;

UIBezierPath *startPath = [UIBezierPath bezierPath];
[startPath moveToPoint:CGPointMake(-2, -30)];
[startPath addLineToPoint:CGPointMake(2, -30)];
[startPath addLineToPoint:CGPointMake(0, 0)];
layer.path = startPath.CGPath;
[self.layer addSublayer:layer];

然后我们再给这个三角形添加动画，一个缩放动画从无到有，一个路径动画从有变没，然后把这两个动画加入到组动画：

CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
group.removedOnCompletion = NO;
group.timingFunction = [CAMediaTimingFunction       functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
group.fillMode = kCAFillModeForwards;
group.duration = 0.5;

CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
scaleAnim.fromValue = @(0.0);
scaleAnim.toValue = @(1.0);
scaleAnim.duration = 0.5 * 0.2f;

UIBezierPath *endPath = [UIBezierPath bezierPath];
[endPath moveToPoint:CGPointMake(-2, -length)];
[endPath addLineToPoint:CGPointMake(2, -length)];
[endPath addLineToPoint:CGPointMake(0, -length)];

CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
pathAnim.fromValue = (__bridge id)layer.path;
pathAnim.toValue = (__bridge id)endPath.CGPath;
pathAnim.beginTime = 0.5 * 0.2f;
pathAnim.duration = 0.5 * 0.8f;
[group setAnimations:@[scaleAnim, pathAnim]];
[layer addAnimation:group forKey:nil];

这样一个三角形的完整的动画就完成了，然后我们利用for循环创建6个即可。

然后还有波纹慢慢扩大至心型图片圆周，再慢慢消失：

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

然后我们可以再加上一些点赞完成后红心旋转的细节处理：   

_likeAfter.transform =     CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.5f, 0.5f);
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

取消点赞动画就是一个旋转加缩放动画:

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

下面直接给上github地址：https://github.com/AlbinGit/Like.git
觉得还不错的同学麻烦在github上给颗星，谢谢！
