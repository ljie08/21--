//
//  LQTabbarViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "LQTabbarViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"

@interface LQTabbarViewController ()

@end

#define TabBarNomal     @[@"read",@"paihang",@"search",@"me"]
#define TabBarSelected  @[@"read_se",@"paihang_se",@"search_se",@"me_se"]


#define TabBarTitles    @[LOCALIZED(@"首页"), LOCALIZED(@"排行榜"), LOCALIZED(@"热搜"), LOCALIZED(@"我的")]

#define DWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]  // 用10进制表示颜色，例如（255,255,255）黑色
#define DWRandomColor DWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
@interface LQTabbarViewController ()

@end

@implementation LQTabbarViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
//    [self setUpTabBarItemTextAttributes];
    [self setUpChildViewController];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    backView.backgroundColor = COLOR_white;
    backView.tag = 200;
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    
//    [[UITabBar appearance] setBackgroundImage:IMGNAMED(@"TabBar_back")];
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    //tabbar被选中的背景颜色
    
//    CGSize indicatorImageSize =CGSizeMake(self.tabBar.bounds.size.width/4, self.tabBar.bounds.size.height);
//    
//    self.tabBar.selectionIndicatorImage = [self drawTabBarItemBackgroundUmageWithSize:indicatorImageSize];
//    
}


//绘制图片

-(UIImage *)drawTabBarItemBackgroundUmageWithSize:(CGSize)size

{
    //开始图形上下文
    
    UIGraphicsBeginImageContext(size);
    
    //获得图形上下文
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx,78/255.0, 76/255.0,96/255.0, 0.1);
    
    CGContextFillRect(ctx,CGRectMake(0,0, size.width, size.height));
    
    
    CGRect rect =CGRectMake(0,0, size.width, size.height);
    
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    [image drawInRect:rect];
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes{
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = COLOR_content;//[Tools hexStringToColor:@"#7a7e96"];//DWRandomColor;//UA_RGB(24, 59, 123);
    normalAttrs[NSFontAttributeName] = FONTSIZE(12);
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = Color_theme;//[Tools hexStringToColor:@"#4E4C60"];//[UIColor colorWithRed:130/255.0 green:195/255.0 blue:212/255.0 alpha:1.0];//
    selectedAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];//BLODFONTSIZE(12);
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}


/**
 *  添加子控制器，我这里值添加了3个，没有占位自控制器
 */
- (void)setUpChildViewController{
    
    
    [self addOneChildViewController:[[OneViewController alloc] init]
                          WithTitle:[TabBarTitles objectAtIndex:0]
                          imageName:[TabBarNomal objectAtIndex:0]
                  selectedImageName:[TabBarSelected objectAtIndex:0]];
    
    [self addOneChildViewController:[[TwoViewController alloc] init]
                          WithTitle:[TabBarTitles objectAtIndex:1]
                          imageName:[TabBarNomal objectAtIndex:1]
                  selectedImageName:[TabBarSelected objectAtIndex:1]];
    
    [self addOneChildViewController:[[ThreeViewController alloc] init]
                          WithTitle:[TabBarTitles objectAtIndex:2]
                          imageName:[TabBarNomal objectAtIndex:2]
                  selectedImageName:[TabBarSelected objectAtIndex:2]];
    
    [self addOneChildViewController:[[FourViewController alloc] init]
                          WithTitle:[TabBarTitles objectAtIndex:3]
                          imageName:[TabBarNomal objectAtIndex:3]
                  selectedImageName:[TabBarSelected objectAtIndex:3]];
    
    
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.tintColor = Color_theme;
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
    
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

