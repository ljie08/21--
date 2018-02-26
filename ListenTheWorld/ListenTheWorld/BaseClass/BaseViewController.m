//
//  BaseViewController.m
//  JLMoney
//
//  Created by ZZY on 16/5/23.
//  Copyright © 2016年 金朗理财. All rights reserved.
//

#import "BaseViewController.h"

static const int  NavicationViewControllersCount = 1;

@interface BaseViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationView.backgroundColor = Color_theme;
    
    UIImage *image = [[UIImage alloc] init];
    
    image = [UIImage imageNamed:@"lemon"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.view.layer.contents = (id) image.CGImage;// 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, self.view.height)];
////    [bgImgView setImage:[UIImage imageNamed:@"bgOne.jpg"]];
//    bgImgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//    bgImgView.userInteractionEnabled = YES;
//    [self.view addSubview:bgImgView];
//    [self.view sendSubviewToBack:bgImgView];
    
    self.childrenView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64, SCREEN_WIDTH, self.view.height-64)];
    self.childrenView.backgroundColor = CLEARCOLOR;
    self.childrenView.userInteractionEnabled = YES;
//    self.childrenView.image = IMGNAMED(@"bgOne.jpg");

//    [_childrenView setImage:[UIImage imageNamed:@"bg"]];
    [self.view insertSubview:_childrenView belowSubview:self.navigationView];
    
    if (self.navigationController.viewControllers.count != NavicationViewControllersCount && !self.isHideNavigationBack) {//不是顶级试图
        
        DZXBarButtonItem *backItem = [DZXBarButtonItem buttonWithImageNormal:[UIImage imageNamed:@"ic_back_nor"]
                                                               imageSelected:[UIImage imageNamed:@"ic_back_nor"]];
        [backItem addTarget:self action:@selector(navigationBackClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationLeftButton = backItem;
    }
    
    
}


#pragma mark - Public Method

/**
 *  点击返回按钮调用(可在子类中重写)
 */
- (void)navigationBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
