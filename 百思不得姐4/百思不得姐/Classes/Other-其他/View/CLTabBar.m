//
//  CLTabBar.m
//  百思不得姐
//
//  Created by 杨博兴 on 16/9/21.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import "CLTabBar.h"

@interface CLTabBar ()

@property(nonatomic,weak)UIButton *publishButton;

@end

@implementation CLTabBar

-(UIButton *)publishButton
{
    if (_publishButton == nil) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishButton addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        _publishButton = publishButton;
    }
    return _publishButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 其他按钮布局
    CGFloat buttonW = self.cl_width / 5;
    CGFloat buttonH = self.cl_height ;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    int buttonIndex = 0;
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            buttonX = buttonIndex * buttonW;
            if (buttonIndex >= 2) {
                buttonX += buttonW;
            }
            subView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            buttonIndex ++;
        }
    }
    // 中间添加按钮布局
    self.publishButton.frame = CGRectMake(0, 0, self.cl_width/5, self.cl_height);
    self.publishButton.center = CGPointMake(self.cl_width *0.5, self.cl_height * 0.5);
}

-(void)pushClick
{
    CLLogfunc
}

@end
