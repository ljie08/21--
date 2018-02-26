//
//  OneModel.h
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)NSInteger addTime;
@property (nonatomic, assign)NSInteger views;
@property (nonatomic, assign)NSInteger aID;

@property (nonatomic, assign)CGFloat   rowHeight;
@property (nonatomic, assign)NSInteger rank;//排行

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
