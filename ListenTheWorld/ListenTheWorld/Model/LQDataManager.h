//
//  LQDataManager.h
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/14.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneModel.h"

@interface LQDataManager : NSObject

+ (LQDataManager *)manager;

- (NSArray *)queryRemindList;
- (BOOL)isExistModel:(OneModel *)model;
- (void)updateLocalRemindData:(OneModel *)content;
- (void)insertRemindData:(OneModel *)content;
- (void)removeRelationShipOfRemindContent:(OneModel *)content;

@end
