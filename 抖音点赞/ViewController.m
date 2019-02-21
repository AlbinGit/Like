//
//  ViewController.m
//  抖音点赞
//
//  Created by Albin on 2019/2/21.
//  Copyright © 2019 Albin. All rights reserved.
//

#import "ViewController.h"
#import "LZLikeView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    LZLikeView *likeView = [[LZLikeView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    likeView.likeDuration = 0.5;
    likeView.zanFillColor = [UIColor redColor];
    [self.view addSubview:likeView];
    
}


@end
