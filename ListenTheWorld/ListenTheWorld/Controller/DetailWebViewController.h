//
//  DetailWebViewController.h
//  ListenTheWorld
//
//  Created by ljie on 2018/1/3.
//  Copyright © 2018年 魔曦. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "OneModel.h"

@interface DetailWebViewController : BaseViewController

@property (nonatomic, strong)OneModel  *model;

@end

@interface WKScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id <WKScriptMessageHandler> scriptMessageDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end
