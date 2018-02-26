//
//  OneCell.h
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneModel.h"

@interface OneCell : UITableViewCell

@property(nonatomic, assign)CGFloat rowHeight;

@property(nonatomic, strong)OneModel  *model;

@end
