//
//  FourViewController.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "FourViewController.h"
#import "FavoriteListViewController.h"
#import "MoreViewController.h"
#import "CustomSearchBar.h"

@interface FourViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationTitle = LOCALIZED(@"我的");
    [self tableView];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 20) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = CLEARCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.childrenView addSubview:_tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ClassifyCellId"];
    }
    return _tableView;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#define ImgArr @[@"",@"",@""]
#define TitleArr @[LOCALIZED(@"收藏的文章"),LOCALIZED(@"清空缓存"),LOCALIZED(@"关于我们")]
#define sectionTitArr @[LOCALIZED(@"    精选收藏"),LOCALIZED(@"    系统设置"),LOCALIZED(@"    更多说明")]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = CLEARCOLOR;
    cell.textLabel.text = TitleArr[indexPath.section];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 20)];
    [label setFont:FONTSIZE(12)];
    label.backgroundColor = CLEARCOLOR;//[[UIColor blackColor] colorWithAlphaComponent:0.2];
    [label setTextColor:[COLOR_title colorWithAlphaComponent:0.5]];
    label.text =sectionTitArr[section];
    
    return label;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        FavoriteListViewController *vc = [[FavoriteListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1){
        
        NSString *text = [NSString stringWithFormat:@"%@%0.2fM",LOCALIZED(@"清除当前缓存"),[self getCacheFileSize]];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"清除") message:LOCALIZED(text) preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:LOCALIZED(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            NSLog(@"点击取消");
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:LOCALIZED(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clearFile];
            
            NSLog(@"点击确认");
            
        }]];
        
        // 由于它是一个控制器 直接modal出来就好了
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        MoreViewController *vc = [[MoreViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//缓存
- (CGFloat)getCacheFileSize{

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [self floderSizeAtPath:cachePath];
}

- (CGFloat)floderSizeAtPath:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    long long foldSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        //获取文件路径
        NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        foldSize += [self fileSizeAtPath:fileAbsolutePath manager:manager];
    }
    return foldSize/(1024*1024.0);
}

- (long long)fileSizeAtPath:(NSString *)path manager:(NSFileManager *)manager{
    
    if ([manager fileExistsAtPath:path]) {
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}

- (void)clearFile{
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
    //读取缓存大小
//    float cacheSize = [self getCacheFileSize] *1024;
//    self.cacheSize.text = [NSString stringWithFormat:@"%.2fKB",cacheSize];
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
