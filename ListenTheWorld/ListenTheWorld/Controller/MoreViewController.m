//
//  MoreViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/15.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)UILabel *blankLabel;
@property (nonatomic, strong)UIImageView *imageView;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];

}

- (void)initUI{
    
    self.navigationTitle = LOCALIZED(@"关于我们");
    [self backButton];
    [self imageView];
    [self blankLabel];
    
}

#pragma mark - actions

-(BOOL)currentLanguageIsEnglish{
    //获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName isEqualToString:@"en"]) {
        return YES;
    }
    
    return NO;
    
}

- (UIButton *)backButton{
    if (!_backButton) {
        UIImage  *img = IMGNAMED(@"ic_back");
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.exclusiveTouch = YES;
        _backButton.backgroundColor = [UIColor clearColor];
        _backButton.frame = CGRectMake(20, 15 + 20, img.size.width, img.size.height);
        
        [_backButton setBackgroundImage:img forState:UIControlStateNormal];
        [_backButton setBackgroundImage:img forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:_backButton];
    }
    return _backButton;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithImage:IMGNAMED(@"flower")];
        _imageView.centerX = SCREEN_WIDTH/2.0;
        _imageView.top = 10;
        [self.childrenView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)blankLabel{
    if (!_blankLabel) {
        _blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.imageView.bottom + 0, SCREEN_WIDTH - 30, 100)];
        _blankLabel.centerX = SCREEN_WIDTH/2.0;
        _blankLabel.textColor = COLOR_title;//[Tools hexStringToColor:@"#4E4C60"];
        _blankLabel.text = LOCALIZED(@"我们旨在为大家提供各种散文的在线阅读包括哲理类、爱情类、生活类、悬疑类等希望大家能够喜欢");
        _blankLabel.numberOfLines = 0;
//        _blankLabel.textAlignment = NSTextAlignmentCenter;
        [self.childrenView addSubview:_blankLabel];
    }
    return _blankLabel;
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
