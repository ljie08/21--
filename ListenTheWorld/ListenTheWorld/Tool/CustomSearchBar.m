//
//  CustomSearchBar.m
//  JoggersV2
//
//  Created by imac on 14-9-22.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "CustomSearchBar.h"

@interface CustomSearchBar()<UITextFieldDelegate>
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UIImageView *textBackImageView;

@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UILabel *promptLabel;

@end

@implementation CustomSearchBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self textBackImageView];
        [self iconImageView];
        [self textField];
        [self promptLabel];
        [self closeButton];
        
        [self.textField becomeFirstResponder];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnSelf)];
        [self addGestureRecognizer:tap];
        self.autoresizesSubviews = YES;
        
        _closeButtomImageName = @"friendSearch_add";
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length > 0) {
        _placeholder = placeholder;
        
        if (!self.showPromptOnCenter) {
            self.textField.placeholder = placeholder;
        }
        else
        {
            self.promptLabel.text = self.placeholder;
            [self.promptLabel sizeToFit];
            
            self.iconImageView.left = (self.width - (self.promptLabel.width + self.iconImageView.width + 7)) / 2;
            self.promptLabel.left = self.iconImageView.right + 7;
            self.promptLabel.centerY = self.iconImageView.centerY;
        }
    }
}

- (void)touchOnSelf
{
    if (self.showPromptOnCenter) {
        self.promptLabel.hidden = YES;
        self.iconImageView.left = self.textBackImageView.left + 9;
        self.textField.hidden = NO;
        self.textField.placeholder = @"";
        [self.textField becomeFirstResponder];
    }
}

- (void)setShowPromptOnCenter:(BOOL)showPromptOnCenter
{
    _showPromptOnCenter = showPromptOnCenter;
    if (showPromptOnCenter) {
        [self.textField resignFirstResponder];
        self.textField.hidden = YES;
        self.promptLabel.hidden = NO;
        
        self.promptLabel.text = self.placeholder;
        [self.promptLabel sizeToFit];
        
        self.iconImageView.left = (self.width - (self.promptLabel.width + self.iconImageView.width + 7)) / 2;
        self.promptLabel.left = self.iconImageView.right + 7;
        self.promptLabel.centerY = self.iconImageView.centerY;
    }
    else
    {
        self.textField.hidden = NO;
        self.textField.placeholder = self.placeholder;
        self.promptLabel.hidden = YES;
        self.iconImageView.left = self.textBackImageView.left + 9;
    }
}

#pragma mark- getter
- (UIImageView *)textBackImageView
{
    if (!_textBackImageView) {
        _textBackImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _textBackImageView.backgroundColor = [UIColor clearColor];
        _textBackImageView.layer.borderWidth = 1;
        _textBackImageView.layer.borderColor = COLOR_title.CGColor;
        _textBackImageView.image = [self stretchImage:[UIImage imageNamed:@"friendSearch_input"] capInsets:UIEdgeInsetsMake(14, 120, 14, 120) resizingMode:UIImageResizingModeStretch];
        _textBackImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_textBackImageView];
    }
    return _textBackImageView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textBackImageView.left + 9, 8, 13, 13)];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.image = [UIImage imageNamed:@"friendSearch_ellipse"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

#define kCloseButtonEdgeWidthX 20
#define kCloseButtonEdgeWidthY 16

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.iconImageView.right + 8, self.textBackImageView.top, self.textBackImageView.width - 20 - 22 - kCloseButtonEdgeWidthX, self.textBackImageView.height)];
        
        _textField.placeholder = @"搜索";
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15];
       // _textField.textColor = [PUUtil getColorByHexadecimalColor:@"4f4f4f"];//8e8e93
        _textField.textColor = [UIColor blackColor];
        _textField.delegate = self;
        _textField.centerY = self.textBackImageView.centerY;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDefault;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        float edgeWidthX = kCloseButtonEdgeWidthX;
        float edgeWidthY = kCloseButtonEdgeWidthY;
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 8 - edgeWidthY / 2, 12 + edgeWidthX, 12 + edgeWidthY);
        _closeButton.right = self.textBackImageView.width;
        _closeButton.hidden = YES;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_closeButton setImage:[UIImage imageNamed:@"friendSearch_add"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

- (void)setCloseButtomImageName:(NSString *)closeButtomImageName
{
    _closeButtomImageName = closeButtomImageName;
    
    float edgeWidthX = kCloseButtonEdgeWidthX;
    float edgeWidthY = kCloseButtonEdgeWidthY;
    UIImage *image = [UIImage imageNamed:self.closeButtomImageName];
    
    self.closeButton.frame = CGRectMake(0, 8 - edgeWidthY / 2, image.size.width + edgeWidthX, image.size.height + edgeWidthY);
    self.closeButton.right = self.textBackImageView.width;
    [self.closeButton setImage:[UIImage imageNamed:self.closeButtomImageName] forState:UIControlStateNormal];
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.hidden = YES;
        _promptLabel.textColor = [UIColor grayColor];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_promptLabel];
    }
    return _promptLabel;
}

#pragma mark- action
- (void)closeButtonPressed:(id)sender
{
    [self cancel];
    if ([self.delegate respondsToSelector:@selector(customSearchBarDidClear:)]) {
        [self.delegate customSearchBarDidClear:self];
    }
}

#pragma mark- textField delegate
- (void)textFieldChanged:(UITextField *)textField
{
    NSString *newStr = textField.text;
    
    self.closeButton.hidden = newStr.length <=0;
    if (!self.isNotRefresh) {
        if ([self.delegate respondsToSelector:@selector(customSearchBar:didSearchWithContent:)]) {
            [self.delegate customSearchBar:self didSearchWithContent:newStr];
        }
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isNotRefresh = NO;
    if ([self.delegate respondsToSelector:@selector(customSearchBarDidBegin:)]) {
        [self.delegate customSearchBarDidBegin:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(customSearchBarDoSearch:)]) {
        [self.delegate customSearchBarDoSearch:self];
    }
    return YES;
}

- (void)cancel
{
    self.textField.text = @"";
    self.closeButton.hidden = YES;
}

- (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *resultImage = nil;
    double systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (systemVersion <5.0) {
        resultImage = [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.right];
    }else if (systemVersion<6.0){
        resultImage = [image resizableImageWithCapInsets:capInsets];
    }else{
        resultImage = [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    }
    return resultImage;
}


@end
