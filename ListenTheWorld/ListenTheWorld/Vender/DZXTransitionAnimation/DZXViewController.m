//
//  DZXViewController.m
//  DZXNavigationController
//
//  Created by Kenway on 15/12/21.
//  Copyright © 2015年 Zahi. All rights reserved.
//

#import "DZXViewController.h"

@interface DZXViewController ()

@end


@implementation DZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //边缘不留白
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *statusbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:statusbarView.bounds];
//    imgView.image = [UIImage imageNamed:@"background_navi"];
    imgView.backgroundColor = CLEARCOLOR;
    [statusbarView addSubview:imgView];
//    [statusbarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_navi"]]];
//    [statusbarView setBackgroundColor:COLOR_002];
    [self.view addSubview:statusbarView];

    
    //初始化navigationView并添加
    self.navigationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navigationView.backgroundColor = CLEARCOLOR;
//    [self.navigationView setImage:[UIImage imageNamed:@"background_navi"]];
    self.navigationView.userInteractionEnabled =  YES;
    //这里设置导航栏的全局颜色
//    self.navigationView.backgroundColor = COLOR_003;
//    [self setNavigationAlpha:1.0f];
    [self.view addSubview:self.navigationView];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
//    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:239/255.0 blue:248/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 改变导航栏背景透明度
- (void)setNavigationAlpha:(CGFloat)navigationAlpha{
    
    if (_navigationAlpha != navigationAlpha) {
        _navigationAlpha = navigationAlpha;
        self.navigationView.backgroundColor = [self.navigationView.backgroundColor colorWithAlphaComponent:navigationAlpha];
    }
}

#pragma mark - 改变导航栏颜色
- (void)setNavigationBackgroundColor:(UIColor *)navigationBackgroundColor{
    self.navigationView.backgroundColor = navigationBackgroundColor;
}

#pragma mark - 设置导航栏标题
- (void)setNavigationTitle:(NSString *)navigationTitle{
    //    根据文本计算宽度
    CGSize labelSize = [navigationTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    
    //初始化labelTitle并调整位置
    if (labelSize.width > SCREEN_WIDTH) {
        labelSize.width = SCREEN_WIDTH;
    }
    
    if (!self.labelTitle) {
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, labelSize.width, 28)];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        
        CGPoint center = self.navigationView.center;
//        _labelTitle.centerX = center.x;
//        _labelTitle.centerY = center.y - 20;
        _labelTitle.centerX = center.x;
        _labelTitle.centerY = center.y + 10;
        
        //文字基本设置
        _labelTitle.textColor = COLOR_title;
        _labelTitle.numberOfLines = 1;
        _labelTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont systemFontOfSize:18.0f];
        
        [self.navigationView addSubview:_labelTitle];
    }else {
        [_labelTitle setWidth:labelSize.width];
        
        //避免后来修改了title后title不居中
        CGPoint center = self.navigationView.center;
        _labelTitle.centerX = center.x;
        
    }
 
    _labelTitle.text = navigationTitle;
    
}

#pragma mark - 自定义导航栏标题位置视图
- (void)setNavigationTitleView:(UIControl *)navigationTitleView{
    
    if (navigationTitleView.frame.origin.x == 0) {
        
        CGPoint titleView;
        titleView.x = SCREEN_WIDTH / 2;
        titleView.y = self.navigationView.frame.size.height / 2 + 7;
        navigationTitleView.center = titleView;
    }else {
        
        CGPoint titleView;
        titleView.x = navigationTitleView.centerX;
        titleView.y = self.navigationView.frame.size.height / 2 + 7;
        navigationTitleView.center = titleView;
    }
    navigationTitleView.backgroundColor = [COLOR_title colorWithAlphaComponent:0.6];
    
    [self.navigationView addSubview:navigationTitleView];
}

#pragma mark - 添加导航栏左侧按钮
- (void)setNavigationLeftButton:(UIButton *)navigationLeftButton{
    
    if (navigationLeftButton != _navigationRightButton) {
        _navigationRightButton = navigationLeftButton;
    }
    
    //判断是文字按钮还是图片按钮，两者坐标稍有不同
    CGFloat leftButtonWidth = navigationLeftButton.frame.size.width;
    CGFloat leftButtonHeight = navigationLeftButton.frame.size.height;
    
    navigationLeftButton.frame = CGRectMake(10, self.navigationView.frame.size.height / 2 - 20, leftButtonWidth, leftButtonHeight);
    
    [self.navigationView addSubview:navigationLeftButton];
}

#pragma mark - 添加导航栏右侧按钮
- (void)setNavigationRightButton:(UIButton *)navigationRightButton{
    //同上
    CGFloat rightButtonWidth = navigationRightButton.frame.size.width;
    CGFloat rightButtonHeight = navigationRightButton.frame.size.height;
    
    navigationRightButton.frame = CGRectMake(SCREEN_WIDTH - navigationRightButton.frame.size.width - 10, self.navigationView.frame.size.height / 2-20, rightButtonWidth, rightButtonHeight);
    
    [self.navigationView addSubview:navigationRightButton];
}

#pragma mark - 添加导航栏左侧按钮集合
- (void)setNavigationLeftButtons:(NSArray<UIButton *> *)navigationLeftButtons{
    CGFloat firstLeftButtonWidth = navigationLeftButtons[0].frame.size.width;
    CGFloat firstLeftButtonHeight = navigationLeftButtons[0].frame.size.height;
    
    CGFloat secondLeftButtonWidth = navigationLeftButtons[1].frame.size.width;
    CGFloat secondLeftButtonHeight = navigationLeftButtons[1].frame.size.height;
    
    navigationLeftButtons[0].frame = CGRectMake(10, self.navigationView.frame.size.height / 2 - 20, firstLeftButtonWidth, firstLeftButtonHeight);
    navigationLeftButtons[1].frame = CGRectMake(10 + firstLeftButtonWidth + 8, self.navigationView.frame.size.height / 2 - 8, secondLeftButtonWidth, secondLeftButtonHeight);
    //8为两个按钮之间的间隔
    
    [self.navigationView addSubview:navigationLeftButtons[0]];
    [self.navigationView addSubview:navigationLeftButtons[1]];
}

#pragma mark - 添加导航栏右侧按钮集合
- (void)setNavigationRightButtons:(NSArray<UIButton *> *)navigationRightButtons{
    CGFloat firstRightButtonWidth = navigationRightButtons[0].frame.size.width;
    CGFloat firstRightButtonHeight = navigationRightButtons[0].frame.size.height;
    
    CGFloat secondRightButtonWidth = navigationRightButtons[1].frame.size.width;
    CGFloat secondRightButtonHeight = navigationRightButtons[1].frame.size.height;
    
    navigationRightButtons[0].frame = CGRectMake(SCREEN_WIDTH - 10 - firstRightButtonWidth, self.navigationView.frame.size.height / 2 - 8, firstRightButtonWidth, firstRightButtonHeight);
    navigationRightButtons[1].frame = CGRectMake(SCREEN_WIDTH - 10 - firstRightButtonWidth - 8 - secondRightButtonWidth, self.navigationView.frame.size.height / 2 - 8, secondRightButtonWidth, secondRightButtonHeight);
    //8为两个按钮之间的间隔
    
    [self.navigationView addSubview:navigationRightButtons[0]];
    [self.navigationView addSubview:navigationRightButtons[1]];
}

@end
