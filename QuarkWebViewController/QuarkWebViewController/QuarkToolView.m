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
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QuarkToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backButton];
        [self addSubview:self.menuButton];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

//- (void)didMoveToSuperview {
//
//    [super didMoveToSuperview];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.titleLabel.center = self.center;
//    self.titleLabel.height = 44;
//    self.backButton.width = 44;
//    self.backButton.height = 44;
//    self.backButton.centerY = self.centerY;
//    self.backButton.left = 12;
//    self.menuButton.centerY = self.centerY;
//    self.menuButton.width = 44;
//    self.menuButton.height = 44;
//    self.menuButton.right = self.right - 12;
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(12, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, 44, 44);
        _menuButton.right = 12;
        [_menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    }
    return _menuButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _titleLabel.center = CGPointMake(kScreenWidth/2, _titleLabel.y + _titleLabel.height/2);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.text = @"测试";
    }
    return _titleLabel;
}

@end
