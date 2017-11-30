//
//  QuarkToolView.m
//  QuarkWebViewController
//
//  Created by lanfeng on 2017/11/28.
//  Copyright © 2017年 lanfeng. All rights reserved.
//

#import "QuarkToolView.h"
#import "UIView+LFExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QuarkToolView()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation QuarkToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backButton];
        [self addSubview:self.menuButton];
        [self addSubview:self.titleButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - event response
- (void)backClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(quarkToolView:backButtonClick:)]) {
        [_delegate quarkToolView:self backButtonClick:button];
    }
}
- (void)menuClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(quarkToolView:menuButtonClick:)]) {
        [_delegate quarkToolView:self menuButtonClick:button];
    }
}
- (void)titleClick:(UIButton *)button {
    [self performSelector:@selector(tClick:) withObject:button afterDelay:0.2];
}

- (void)tClick:(UIButton *)button {
    NSLog(@"单击");
    if (_delegate && [_delegate respondsToSelector:@selector(quarkToolView:titleButtonClick:)]) {
        [_delegate quarkToolView:self titleButtonClick:button];
    }
}

- (void)titleRepeatClick:(UIButton *)button {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tClick:) object:button];
    [self performSelector:@selector(tDoubleClick:) withObject:button afterDelay:0.2];
}

- (void)tDoubleClick:(UIButton *)button {
    NSLog(@"双击");
    if (_delegate && [_delegate respondsToSelector:@selector(quarkToolView:titleButtonDoubleClick:)]) {
        [_delegate quarkToolView:self titleButtonDoubleClick:button];
    }
}


#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(12, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(kScreenWidth - 44 - 12, 0, 44, 44);
        [_menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 44, 44);
        _titleButton.center = CGPointMake(kScreenWidth/2, _titleButton.y + _titleButton.height/2);
        [_titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _titleButton.backgroundColor = [UIColor redColor];
        [_titleButton setTitle:@"测试" forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleButton addTarget:self action:@selector(titleRepeatClick:) forControlEvents:UIControlEventTouchDownRepeat];
    }
    return _titleButton;
}

@end
