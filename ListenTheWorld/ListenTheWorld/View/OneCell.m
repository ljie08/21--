//
//  OneCell.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "OneCell.h"

@interface OneCell ()

@property (nonatomic,strong) UILabel *lab_title;
@property (nonatomic,strong) UILabel *lab_time;
@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic,strong) UILabel *lab_tip;

@property (nonatomic,strong) UIView  *lineView;

@end

@implementation OneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        [self lab_title];
        [self lab_time];
        [self lab_tip];
//        [self lineView];
    }
    return self;
}

- (void)setModel:(OneModel *)model{
    
    _model = model;
    self.lab_title.text = model.title;
    self.lab_time.text = [self getAddTimeString:model.addTime];
    CGFloat height = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONTSIZE(16)} context:nil].size.height;
    self.lab_tip.height = height + 1;
    self.lab_tip.text = model.content;
    self.rowHeight = self.lab_tip.bottom + 10;
    model.rowHeight = self.rowHeight;
//    self.lineView.top = self.lab_tip.bottom + 10;
    
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
        _lab_title = [[UILabel alloc]initWithFrame:CGRectMake(15,10, SCREEN_WIDTH - 30, 28)];
        _lab_title.backgroundColor = CLEARCOLOR;
        [_lab_title setFont:FONTSIZE(16)];
        [_lab_title setTextColor:COLOR_title];
        [_lab_title setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_title];
        
    }
    return _lab_title;
}

- (UILabel *)lab_time{
    if (!_lab_time) {
        _lab_time = [[UILabel alloc]initWithFrame:CGRectMake(15,self.lab_title.bottom + 5, self.contentView.width, 15)];
        _lab_time.backgroundColor = CLEARCOLOR;
        [_lab_time setFont:FONTSIZE(12)];
        [_lab_time setTextColor:COLOR_content];
        [_lab_time setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_time];
    }
    return _lab_time;
}

-(UILabel *)lab_tip{
    if (!_lab_tip) {
        _lab_tip = [[UILabel alloc]initWithFrame:CGRectMake(15,self.lab_time.bottom + 2, self.lab_title.width, 0)];
        _lab_tip.backgroundColor = CLEARCOLOR;
        [_lab_tip setFont:FONTSIZE(14)];
        [_lab_tip setTextColor:COLOR_content];//[Tools hexStringToColor:@"#4E4C60"]
        [_lab_tip setNumberOfLines:0];
        [_lab_tip setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_tip];
        
    }
    return _lab_tip;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 1)];
        _lineView.backgroundColor = [COLOR_title colorWithAlphaComponent:0.2];//[[Tools hexStringToColor:@"#4E4C60"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
