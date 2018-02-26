//
//  TwoViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "TwoViewController.h"
#import "DetailViewController.h"
#import "DetailWebViewController.h"
#import "OneModel.h"
#import "TwoCell.h"

#define TEMPARR @[LOCALIZED(@"周榜"),LOCALIZED(@"月榜"),LOCALIZED(@"年榜")]
#define TypeArr @[@(7),@(30),@(365)]

@interface TwoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *topScrollView;
@property (nonatomic,strong) UIScrollView *bottomScrollView;

@end

@implementation TwoViewController
{
    NSMutableArray *_btnArr;
    UIView *_slideLineView;
    NSMutableArray *_dataArr;
    int _pageno;
    NSInteger _index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTitle = LOCALIZED(@"热门榜单");
    _btnArr = [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageno = 0;
    _index = 0;
    [self updateUI];
    [self requestData];
}

- (void)requestData{
    
    if (_dataArr.count > 0) {
        [_dataArr removeAllObjects];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud showAnimated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kRankUrl,(long)[TypeArr[_index] integerValue]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration ] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if (error) {
            return ;
        }
        NSDictionary *j = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = j[@"items"];
        for (NSDictionary *dict in arr) {
            OneModel *model = [[OneModel alloc] initWithDictionary:dict];
            [_dataArr addObject:model];
        }
        [[self getCurrentTableViewWithIndex:_index] reloadData];
    }];
    [dataTask resume];
}

-(UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45)];
        _topScrollView.contentSize = CGSizeMake((SCREEN_WIDTH/3)*TEMPARR.count, 0);
        
        
        for (int i=0; i<TEMPARR.count; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3.0), 0, SCREEN_WIDTH/3.0, 40)];
            [btn setTitle:TEMPARR[i] forState:UIControlStateNormal];
            
            [btn setTitleColor:COLOR_content forState:UIControlStateNormal];
            [btn setTitleColor:Color_theme forState:UIControlStateSelected];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [btn setTag:10+i];
            [btn addTarget:self action:@selector(topBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrollView addSubview:btn];
            [_btnArr addObject:btn];
            
            if (i==0) {
                btn.selected = YES;
            }
        }
        
        _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 42, SCREEN_WIDTH/3.0-30, 2)];
        [_slideLineView setBackgroundColor:Color_theme];
        [_topScrollView addSubview:_slideLineView];
        
    }
    return _topScrollView;
}

- (UIScrollView *)bottomScrollView{
    
    if (!_bottomScrollView) {
        
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,109, SCREEN_WIDTH, SCREEN_HEIGHT - self.topScrollView.bottom)];
        _bottomScrollView.contentSize =CGSizeMake( SCREEN_WIDTH *TEMPARR.count, SCREEN_HEIGHT - 109 - 50);
        _bottomScrollView.delegate = self;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.scrollsToTop = NO;
        _bottomScrollView.pagingEnabled = YES;
        
        for (NSInteger i = 0; i < TEMPARR.count ; i++) {
            
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 109 - 50) style:UITableViewStyleGrouped];
            tableView.backgroundColor = CLEARCOLOR;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.tag = 100 + i;
            [_bottomScrollView addSubview:tableView];
            [tableView registerClass:[TwoCell class] forCellReuseIdentifier:@"TwoCellID"];
        }
    }
    return _bottomScrollView;
}


- (UITableView *)getCurrentTableViewWithIndex:(NSInteger)index{
    
    UITableView *tableview = [self.bottomScrollView viewWithTag:100 + index];
    
    return tableview;
}


-(void)updateUI{
    
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.bottomScrollView];
}

#pragma mark -- actions
-(void)topBtnClickAction:(UIButton *)btn{
    
    NSInteger index = btn.tag - 10 ;
    for (UIButton *tempBtn in _btnArr) {
        if (tempBtn.tag == btn.tag) {
            tempBtn.selected = YES;
        }else{
            tempBtn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.1 animations:^{
        [_slideLineView setLeft:(SCREEN_WIDTH/TEMPARR.count) * index+15];
        [self.bottomScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index,0)];
    }];
    
    _index = index;
    [self requestData];
}

#pragma mark - scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.bottomScrollView){
        CGFloat offsetX = scrollView.contentOffset.x;
        
        NSInteger index = (int)(offsetX / scrollView.width);
        
        for (UIButton *tempBtn in _btnArr) {
            if (tempBtn.tag == 10 + index) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            [_slideLineView setLeft:(SCREEN_WIDTH/TEMPARR.count) * index+15];
        }];
        _index = index;
        [self requestData];
    }
    
    
}


#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellReuse = @"TwoCellID";
    TwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    OneModel *model = _dataArr[indexPath.row];
    model.rank = indexPath.row + 1;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.model = _dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
   
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
