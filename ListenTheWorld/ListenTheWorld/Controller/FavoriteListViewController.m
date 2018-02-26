//
//  FavoriteListViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/14.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "DetailViewController.h"
#import "DetailWebViewController.h"
#import "LQDataManager.h"
#import "OneModel.h"
#import "OneCell.h"

@interface FavoriteListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton  *backButton;
@property (nonatomic, strong)UILabel *blankLabel;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)LQDataManager  *manager;


@end

@implementation FavoriteListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = LOCALIZED(@"收藏列表");//LOCALIZED(@"首页");
    
    [self backButton];

    [self tableView];
    self.manager = [LQDataManager manager];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self queryLocalData];
}

- (void)queryLocalData{
    
    if ([self.manager queryRemindList].count > 0) {
        [self.dataArray addObjectsFromArray:[self.manager queryRemindList]];
        [self.tableView reloadData];
    }
    self.blankLabel.hidden = self.dataArray.count > 0 ? YES : NO;
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
        CGFloat height =  SCREEN_HEIGHT - 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEARCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.childrenView addSubview:_tableView];
        [_tableView registerClass:[OneCell class] forCellReuseIdentifier:@"ClassifyCellId"];
    }
    return _tableView;
}

- (UILabel *)blankLabel{
    if (!_blankLabel) {
        _blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _blankLabel.centerY = (SCREEN_HEIGHT - 64)/2.0;
        _blankLabel.textColor = COLOR_title;//[Tools hexStringToColor:@"#4E4C60"];
        _blankLabel.text = LOCALIZED(@"亲,暂时还没有收藏喔");
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
