//
//  ViewController.m
//  QuarkWebViewController
//
//  Created by lanfeng on 2017/11/27.
//  Copyright © 2017年 lanfeng. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "QuarkWebViewController.h"

static const CGFloat kMargin = 12.0;
static const CGFloat kButtonWidth = 250;

@interface ViewController ()
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *uiwebViewButton;
@property (nonatomic, strong) UIButton *wkwebViewButton;
@property (nonatomic, strong) UIButton *sonicwebViewButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.uiwebViewButton];
    [self.view addSubview:self.wkwebViewButton];
    [self.view addSubview:self.sonicwebViewButton];
    [self LF_setupSubviews];
}

- (void)LF_setupSubviews {
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kMargin);
        make.right.equalTo(self.view).offset(-kMargin);
        make.top.equalTo(self.view).offset(100);
    }];
    
    [self.uiwebViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextField);
        make.top.equalTo(self.inputTextField.mas_bottom).offset(kMargin);
        make.width.equalTo(@(kButtonWidth));
        make.height.equalTo(@44);
    }];
    
    [self.wkwebViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextField);
        make.top.equalTo(self.uiwebViewButton.mas_bottom).offset(kMargin);
        make.width.equalTo(@(kButtonWidth));
        make.height.equalTo(@44);
    }];

    [self.sonicwebViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextField);
        make.top.equalTo(self.wkwebViewButton.mas_bottom).offset(kMargin);
        make.width.equalTo(@(kButtonWidth));
        make.height.equalTo(@44);
    }];
}

#pragma mark - event response
- (void)toUIWebView:(UIButton *)button {
    [self.navigationController pushViewController:[[QuarkWebViewController alloc] initWith:JPWebViewTypeUIWebView url:self.inputTextField.text] animated:YES];
}
- (void)toWKWebView:(UIButton *)button {
    [self.navigationController pushViewController:[[QuarkWebViewController alloc] initWith:JPWebViewTypeWKWebView url:self.inputTextField.text] animated:YES];
}
- (void)toSonikWebView:(UIButton *)button {
    
}

#pragma mark - getters and setters
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.backgroundColor = [UIColor greenColor];
    }
    return _inputTextField;
}

- (UIButton *)uiwebViewButton {
    if (!_uiwebViewButton) {
        _uiwebViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uiwebViewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_uiwebViewButton setTitle:@"使用uiwebview打开" forState:UIControlStateNormal];
        [_uiwebViewButton addTarget:self action:@selector(toUIWebView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uiwebViewButton;
}

- (UIButton *)wkwebViewButton {
    if (!_wkwebViewButton) {
        _wkwebViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wkwebViewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_wkwebViewButton setTitle:@"使用wkwebview打开" forState:UIControlStateNormal];
        [_wkwebViewButton addTarget:self action:@selector(toWKWebView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wkwebViewButton;
}

- (UIButton *)sonicwebViewButton {
    if (!_sonicwebViewButton) {
        _sonicwebViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sonicwebViewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sonicwebViewButton setTitle:@"使用sonicwebview打开" forState:UIControlStateNormal];
        [_sonicwebViewButton addTarget:self action:@selector(toSonikWebView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sonicwebViewButton;
}

@end
