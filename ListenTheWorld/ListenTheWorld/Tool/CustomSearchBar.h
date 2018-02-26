//
//  CustomSearchBar.h
//  JoggersV2
//
//  Created by imac on 14-9-22.
//  Copyright (c) 2014年 hupu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSearchBar;

@protocol CustomSearchBarDelegate <NSObject>
@optional;
- (void)customSearchBarDidBegin:(CustomSearchBar *)search;
- (void)customSearchBar:(CustomSearchBar *)searchBar didSearchWithContent:(NSString *)content;
- (void)customSearchBarDidClear:(CustomSearchBar *)searchBar;
- (void)customSearchBarDoSearch:(CustomSearchBar *)searchBar;
@end

@interface CustomSearchBar : UIView
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, weak)id<CustomSearchBarDelegate>delegate;
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, assign)BOOL showPromptOnCenter;
@property (nonatomic, strong)NSString *closeButtomImageName;
@property (nonatomic, assign)BOOL isNotRefresh;
- (void)cancel;
@end
