//
//  OneViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "OneViewController.h"
#import "DetailViewController.h"
#import "DetailWebViewController.h"
#import "OneCell.h"
#import "OneModel.h"

@interface OneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)UILabel *blankLabel;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation OneViewController{
    NSInteger _page;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count <= 0) {
        [self requestData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = self.searchContent.length > 0 ? self.searchContent :LOCALIZED( @"首页");
    if (self.searchContent) {
        [self backButton];
    }
    [self tableView];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    _page = 1;

    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = YES;
}


- (void)requestData{
    
    if (_page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud showAnimated:YES];

    NSString *urlStr;
    if (self.searchContent) {

        urlStr = [NSString stringWithFormat:kSearchKeyWord,[self.searchContent stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    }else{
        urlStr = [NSString stringWithFormat:kHomeUrl,(long)_page];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration ] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        if (error == nil) {
            NSDictionary *j = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = j[@"items"];
            for (NSDictionary *dict in arr) {
                OneModel *model = [[OneModel alloc] initWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            if (self.searchContent) {
                self.blankLabel.hidden = self.dataArray.count ? YES :NO;
            }
            [self.tableView reloadData];
        }else{
            
        }
        
    }];
    [dataTask resume];
}

#pragma mark - actions

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

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat height = self.searchContent.length > 0 ? SCREEN_HEIGHT - 64 : SCREEN_HEIGHT - 64 - 49;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEARCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.childrenView addSubview:_tableView];
        [_tableView registerClass:[OneCell class] forCellReuseIdentifier:@"ClassifyCellId"];
        
        if (self.searchContent.length <= 0) {
            _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _page = 1;
                [self requestData];
                // 这个地方是网络请求的处理
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_tableView.mj_header endRefreshing];
                });
            }];
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _page ++;
                [self requestData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_tableView.mj_footer endRefreshing];
                });
            }];
        }
       
    }
    return _tableView;
}

- (UILabel *)blankLabel{
    if (!_blankLabel) {
        _blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _blankLabel.centerY = SCREEN_HEIGHT/2.0;
        _blankLabel.textColor = COLOR_title;//[Tools hexStringToColor:@"#4E4C60"];
        _blankLabel.text = LOCALIZED(@"亲,换个关键词试试");
        _blankLabel.numberOfLines = 0;
        _blankLabel.textAlignment = NSTextAlignmentCenter;
        [self.childrenView addSubview:_blankLabel];
        _blankLabel.hidden = YES;
    }
    return _blankLabel;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OneModel *model = self.dataArray[indexPath.row];
    if (model.rowHeight <= 0) {
        OneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCellId"];
        cell.model = self.dataArray[indexPath.row];
    }
    
    return model.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCellId"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailWebViewController *web = [[DetailWebViewController alloc] init];
    web.model = self.dataArray[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
