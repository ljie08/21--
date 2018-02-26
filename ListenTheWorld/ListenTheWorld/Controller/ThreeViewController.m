//
//  ThreeViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "ThreeViewController.h"
#import "OneViewController.h"
#import "CustomSearchBar.h"

@interface ThreeViewController ()<CustomSearchBarDelegate>

@property (nonatomic,strong) CustomSearchBar    *searchBar;
@property (nonatomic,strong) UIView             *searchView;
@property (nonatomic,strong) UIView             *hotSearchView;

@property (nonatomic,strong) NSMutableArray     *hotArray;
@property (nonatomic, copy)  NSString           *searchContent;


@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hotArray = [NSMutableArray array];
    self.navigationTitle = LOCALIZED(@"搜索");
    [self searchView];
    [self requestData];
}

- (void)requestData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud showAnimated:YES];
    NSURL *url = [NSURL URLWithString:kHotTypeUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration ] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            NSArray *j = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self.hotArray addObjectsFromArray:j];
            if ([self.hotArray count]) {
                [self hotSearchView];
            }
        }
        
    }];
    [dataTask resume];
}


- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 44)];
        _searchView.centerX = SCREEN_WIDTH / 2;
        _searchView.backgroundColor = [UIColor clearColor];
        [self.childrenView addSubview:_searchView];
        
        float edgeW = 15;
        /*
         if (iPhone6) {
         edgeW = 20;
         }
         else if (iPhone6) {
         edgeW = 28;
         }
         */
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.backgroundColor = [UIColor clearColor];
        rightButton.frame = CGRectMake(0, 0, 80, 20);
        [rightButton setTitle:LOCALIZED(@"取消") forState:UIControlStateNormal];
        [rightButton sizeToFit];
        rightButton.right = self.searchView.width - edgeW;
        rightButton.centerY = self.searchView.height / 2;
        [rightButton setTitleColor:COLOR_title forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [rightButton addTarget:self action:@selector(searchRightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:rightButton];
        
        float delatX = 8;
        /*
         if (iPhone6) {
         delatX = 9;
         }
         else if (iPhone6P) {
         delatX = 10;
         }
         */
        self.searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(10, 0,rightButton.left - delatX - edgeW, 28)];
        self.searchBar.closeButtomImageName = @"gear_search_close";
        self.searchBar.placeholder = LOCALIZED(@"搜索你喜欢的文章");
        self.searchBar.delegate = self;
        self.searchBar.centerY = _searchView.height / 2;
        self.searchBar.textField.returnKeyType = UIReturnKeySearch;
        [_searchView addSubview:self.searchBar];
    }
    return _searchView;
}

- (UIView *)hotSearchView{
    if (!_hotSearchView) {
        
        _hotSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom + 20, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom - 20 - 49)];
        _hotSearchView.backgroundColor = CLEARCOLOR;
        [self.childrenView addSubview:_hotSearchView];
        
         UILabel  *_lab_title = [[UILabel alloc]initWithFrame:CGRectMake(15,10, SCREEN_WIDTH - 30, 30)];
        _lab_title.backgroundColor = CLEARCOLOR;
        [_lab_title setFont:BLODFONTSIZE(20)];
        [_lab_title setTextColor:COLOR_title];
        [_lab_title setUserInteractionEnabled:YES];
        _lab_title.text =LOCALIZED( @"热搜关键词");
        [_hotSearchView addSubview:_lab_title];
        
        CGFloat maxWidth = 15;
        CGFloat top =  _lab_title.bottom + 10;
        for (NSInteger i = 0; i < self.hotArray.count; i ++) {
            
            NSString *text = self.hotArray[i];
             CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONTSIZE(16)} context:nil].size.width + 10;
            
            if (maxWidth + width > SCREEN_WIDTH - 15) {
                top += 40;
                maxWidth = 15;
            }
            
            CGRect frame = CGRectMake(maxWidth, top, width, 30);
            UILabel  *_lab= [[UILabel alloc]initWithFrame:frame];
            _lab.backgroundColor = CLEARCOLOR;
            _lab.layer.cornerRadius = 5;
            _lab.layer.borderWidth = 1.0;
            _lab.layer.borderColor = [Color_theme colorWithAlphaComponent:0.5].CGColor;

            [_lab setFont:FONTSIZE(16)];
            [_lab setTextColor:COLOR_content];
            [_lab setUserInteractionEnabled:YES];
            _lab.textAlignment = NSTextAlignmentCenter;
            _lab.text = text;
            _lab.tag = 100 + i;
            [_hotSearchView addSubview:_lab];
            maxWidth = maxWidth + width + 10;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterSearchList:)];
            [_lab addGestureRecognizer:tap];
        }
    }
    return _hotSearchView;
}

#pragma mark - actions

- (void)searchRightButtonPressed:(UIButton *)btn{
    self.searchContent = nil;
    self.searchBar.textField.text = nil;
    [self.view endEditing:YES];
}

- (void)enterSearchList:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    self.searchContent = self.hotArray[label.tag - 100];
    [self enterSearch];
}

- (void)enterSearch{
    OneViewController *vc = [[OneViewController alloc] init];
    vc.searchContent = self.searchContent;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - CustomSearchBarDelegate
- (void)customSearchBar:(CustomSearchBar *)searchBar didSearchWithContent:(NSString *)content
{
        self.searchContent = content;
}

- (void)customSearchBarDidClear:(CustomSearchBar *)searchBar
{
        self.searchContent = nil;
}

- (void)customSearchBarDoSearch:(CustomSearchBar *)searchBar
{
    [self.view endEditing:YES];
    // 网络搜索
        [self enterSearch];
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
