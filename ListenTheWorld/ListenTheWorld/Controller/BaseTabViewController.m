//
//  BaseTabViewController.m
//  ListenTheWorld
//
//  Created by ljie on 2018/1/4.
//  Copyright © 2018年 魔曦. All rights reserved.
//

#import "BaseTabViewController.h"
#import "NavigationController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UITabBar appearance] setBarTintColor:COLOR_white];
//    [UITabBar appearance].translucent = NO;
    
    [self addChildVC];
    
    //去除 TabBar 自带的顶部阴影
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}
//@[LOCALIZED(@"首页"), LOCALIZED(@"排行榜"), LOCALIZED(@"热搜"), LOCALIZED(@"我的")]
- (void)addChildVC {
    OneViewController *one = [[OneViewController alloc] init];
    [self setChildVCWithViewController:one title:LOCALIZED(@"首页") image:IMGNAMED(@"read") selectedImg:nil];
    
    TwoViewController *two = [[TwoViewController alloc] init];
    [self setChildVCWithViewController:two title:LOCALIZED(@"排行榜") image:IMGNAMED(@"paihang") selectedImg:nil];
    
    ThreeViewController *three = [[ThreeViewController alloc] init];
    [self setChildVCWithViewController:three title:LOCALIZED(@"热搜") image:IMGNAMED(@"search") selectedImg:nil];
    
    FourViewController *four = [[FourViewController alloc] init];
    [self setChildVCWithViewController:four title:LOCALIZED(@"我的") image:IMGNAMED(@"me") selectedImg:nil];
}

- (void)setChildVCWithViewController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image selectedImg:(UIImage *)selectedImg {
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:controller];
    self.tabBar.tintColor = Color_theme;
    
    nav.title = title;
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
