//
//  TwoCell.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/13.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "TwoCell.h"

@interface TwoCell ()

@property (nonatomic,strong) UILabel *lab_title;
@property (nonatomic,strong) UILabel *lab_time;
@property (nonatomic,strong) UILabel *lab_count;//阅读量
@property (nonatomic,strong) UILabel *lab_tip;
@property (nonatomic,strong) UILabel *lab_rank;

@end

@implementation TwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        [self lab_rank];
        [self lab_title];
//        [self lab_time];
        [self lab_count];
//        [self lab_tip];
    }
    return self;
}

- (void)setModel:(OneModel *)model{
    
    _model = model;
    
    NSString *rankStr =  [NSString stringWithFormat:@"%ld.",(long)model.rank];
    CGFloat width = [rankStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} context:nil].size.width;
    self.lab_rank.width = width;
    self.lab_title.left = self.lab_rank.right;
    self.lab_title.width = SCREEN_WIDTH - self.lab_rank.right - 70;


    self.lab_rank.text = rankStr;
    self.lab_title.text = model.title;
//    self.lab_time.text = [self getAddTimeString:model.addTime];
    self.lab_count.text = [NSString stringWithFormat:@"%@\n%ld",LOCALIZED(@"阅读"),(long)model.views];
    
    CGFloat height = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONTSIZE(16)} context:nil].size.height;
    self.lab_tip.height = height + 1;
    self.lab_tip.text = model.content;
    model.rowHeight = self.lab_tip.bottom + 10;
    
}

- (NSString *)getAddTimeString:(NSInteger)addTime{
    
    //    NSDate *date = [NSDate date];
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:addTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *addTimeStr = [formatter stringFromDate:addDate];
    return addTimeStr;
}

-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc]initWithFrame:CGRectMake(self.lab_rank.right,10, 0, 30)];
        _lab_title.backgroundColor = CLEARCOLOR;
        [_lab_title setFont:FONTSIZE(18)];
        [_lab_title setTextColor:COLOR_title];
        [_lab_title setUserInteractionEnabled:YES];
//        _lab_title.lineBreakMode = NSLineBreakByTruncatingTa;
        [self.contentView addSubview:_lab_title];
        
    }
    return _lab_title;
}

- (UILabel *)lab_time{
    if (!_lab_time) {
        _lab_time = [[UILabel alloc]initWithFrame:CGRectMake(self.lab_title.left,self.lab_title.bottom + 5, self.lab_title.width, 20)];
        _lab_time.backgroundColor = CLEARCOLOR;
        [_lab_time setFont:FONTSIZE(12)];
        [_lab_time setTextColor:[COLOR_title colorWithAlphaComponent:0.5]];
        [_lab_time setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_time];
    }
    return _lab_time;
}

- (UILabel *)lab_count{
    if (!_lab_count) {
        _lab_count = [[UILabel alloc]initWithFrame:CGRectMake(15,10,50, 30)];
        _lab_count.right = SCREEN_WIDTH - 15;
        _lab_count.backgroundColor = CLEARCOLOR;
//        _lab_count.layer.cornerRadius = 5;
        _lab_count.layer.borderWidth = 1.0;
        _lab_count.layer.borderColor = [COLOR_title colorWithAlphaComponent:0.5].CGColor;
        [_lab_count setFont:FONTSIZE(12)];
        [_lab_count setTextColor:COLOR_content];//[Tools hexStringToColor:@"#4E4C60"]
        [_lab_count setNumberOfLines:2];
        [_lab_count setUserInteractionEnabled:YES];
        [_lab_count setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_lab_count];
    }
    return _lab_count;
}

-(UILabel *)lab_tip{
    if (!_lab_tip) {
        _lab_tip = [[UILabel alloc]initWithFrame:CGRectMake(15,self.lab_time.bottom + 2, self.lab_title.width, 0)];
        _lab_tip.backgroundColor = CLEARCOLOR;
        [_lab_tip setFont:FONTSIZE(14)];
        [_lab_tip setTextColor:[COLOR_title colorWithAlphaComponent:0.5]];//[Tools hexStringToColor:@"#4E4C60"]
        [_lab_tip setNumberOfLines:0];
        [_lab_tip setUserInteractionEnabled:YES];
//        [self.contentView addSubview:_lab_tip];
        
    }
    return _lab_tip;
}

- (UILabel *)lab_rank{
    if (!_lab_rank) {
        
        _lab_rank = [[UILabel alloc]initWithFrame:CGRectMake(15,10,0, 30)];
        _lab_rank.backgroundColor = CLEARCOLOR;
        [_lab_rank setFont:BLODFONTSIZE(20)];
        [_lab_rank setTextColor:[COLOR_title colorWithAlphaComponent:0.5]];//[Tools hexStringToColor:@"#4E4C60"]
        [_lab_rank setNumberOfLines:0];
        [_lab_rank setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_rank];
    }
    return _lab_rank;
}

@end
