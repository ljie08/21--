//
//  OneModel.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "OneModel.h"

@implementation OneModel

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.title = dictionary[@"title"];
        self.content = dictionary[@"jianjie"];
        self.aID = [dictionary[@"ID"] integerValue];
        self.addTime = [dictionary[@"edittime"] integerValue];
        self.views = [dictionary[@"views"] integerValue];
        
    }
    return self;
}

@end
