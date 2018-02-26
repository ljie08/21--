//
//  DetailViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/13.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "IMYWebView.h"
#import "LQDataManager.h"

@interface DetailViewController ()<IMYWebViewDelegate,WKScriptMessageHandler> {
    UIProgressView *_progressView;
    NSTimer *_timer;
    BOOL _isEnd;//是否加载完成
}

@property (nonatomic, strong)IMYWebView *wkWebView;
@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)LQDataManager *manager;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initProgressview];
    [self initUI];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kHomeDetailUrl,(long)self.model.aID]];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.manager = [LQDataManager manager];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 移除 progress view
    [_progressView removeFromSuperview];
}

- (void)loadWebview {
    if (_isEnd) {
        if (_progressView.progress >= 1) {
            _progressView.hidden = YES;
            [_timer invalidate];
        } else {
            _progressView.progress += 0.1;
        }
    } else {
        _progressView.progress += 0.05;
        if (_progressView.progress >= 0.95) {
            _progressView.progress = 0.95;
        }
    }
}


- (void)initUI{
    
    self.navigationTitle = LOCALIZED(@"详情加载中...");
    [self backButton];
//    [self.topContainerView addSubview:self.backButton];
//    UIImage  *img1 = IMGNAMED(@"favorite");
//    self.navigationRightButton.frame = CGRectMake(self.containerView.width-img1.size.width-2, 0, img1.size.width, img1.size.height);
//    self.rightButton.centerY = self.topContainerView.height/2;
//    self.rightButton.right = SCREEN_WIDTH - 20;
//    [self.rightButton setImage:img1 forState:UIControlStateNormal];
//    [self.rightButton setImage:IMGNAMED(@"unfavorite") forState:UIControlStateSelected];
//    self.rightButton.selected = [self.dataManager isExistModel:self.model];
    
    [self wkWebView];
    
}

//初始化进度条
- (void)initProgressview {
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 0, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progressTintColor = COLOR_title;
    [self.wkWebView addSubview:_progressView];
    
}

#pragma mark - actions

- (void)rightBarBtnClickAction:(UIButton *)btn{
    
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [self.dataManager insertRemindData:self.model];
//        [HUDUtils showHUDToast:LOCALIZED(@"收藏成功")];
//    }else{
//        [self.dataManager removeRelationShipOfRemindContent:self.model];
//        [HUDUtils showHUDToast:LOCALIZED(@"取消收藏")];
//    }
}

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

- (IMYWebView *)wkWebView{
    if (!_wkWebView) {
        
//        WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
//        WKPreferences *preferences = [WKPreferences new];
//        preferences.javaScriptCanOpenWindowsAutomatically = YES;
//        configuration.preferences = preferences;
//        configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
//        [configuration.userContentController addScriptMessageHandler:self name:@"bookmark"];
        
        _wkWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT - 64) usingUIWebView:NO];
        _wkWebView.delegate = self;
        _wkWebView.backgroundColor = CLEARCOLOR;
        _wkWebView.opaque = NO;
        [self.view addSubview:_wkWebView];
        [_wkWebView addScriptMessageHandler:self name:@"baiduImagePlus"];
    }
    return _wkWebView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- IMYWebview

- (void)webViewDidStartLoad:(IMYWebView*)webView{
    
    _progressView.progress = 0;
    _isEnd = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(loadWebview) userInfo:nil repeats:YES];
    
}

- (void)webViewDidFinishLoad:(IMYWebView*)webView{
    
//    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
//    //获取整个页面的HTMLstring
//    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
//        NSLog(@"html  = %@",HTMLsource);
////        if (!error && NOEmptyStr(HTMLsource)) { [weakSelf removeADByHTMLSource:HTMLsource];
////        }
//    }];
//    
//    NSString *removeADStr = @"document.getElementById('baiduImagePlus').style.display ='none';";
//    [webView evaluateJavaScript:removeADStr completionHandler:^(id obj, NSError *error) {
//        
//        if (error) {
//            NSLog(@"remove = %@",error.description);
//
//        }
//    }];
//    article-ad-random
//    [_wkWebView evaluateJavaScript:@"document.documentElement.getElementsByClassName('article-ad-random')[0].style.display='none';" completionHandler:nil];
    
    if ([self.manager isExistModel:self.model]) {
        NSString *str = @"document.getElementById('bookmark').innerHTML = '已收藏';";
        
        [webView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
            if (error) {
                NSLog(@"error = %@",error.description);
            }else{
                NSLog(@"初始修改成功");
            }
        }];
    }
    
    _isEnd = YES;
    self.navigationTitle = LOCALIZED(@"详情");
}

- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error{
    
}

- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[[request URL] absoluteString] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
//    NSLog(@"request = %@",requestString);
    if ([requestString rangeOfString:@"baidu.com"].location != NSNotFound) {//去除广告
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"可点击");
        
        //收藏  bookmark://21979
        if ([requestString rangeOfString:@"bookmark://"].location != NSNotFound ) {
            NSString *str;
            if (![self.manager isExistModel:self.model]) {
                [self.manager insertRemindData:self.model];
                str = @"document.getElementById('bookmark').innerHTML = '已收藏';";
                
            }else{
                [self.manager removeRelationShipOfRemindContent:self.model];
                str = @"document.getElementById('bookmark').innerHTML = '收藏';";
                
            }
            
            [webView evaluateJavaScript:str completionHandler:^(id obj, NSError *error) {
                if (error) {
                    NSLog(@"error = %@",error.description);
                }
            }];
        }
        
    }
    return YES;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"baiduImagePlus"]) {
        NSLog(@"重大");
    }
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

