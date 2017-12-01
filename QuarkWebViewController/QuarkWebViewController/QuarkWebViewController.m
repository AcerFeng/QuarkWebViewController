//
//  QuarkWebViewController.m
//  QuarkWebViewController
//
//  Created by lanfeng on 2017/11/27.
//  Copyright © 2017年 lanfeng. All rights reserved.
//

#import "QuarkWebViewController.h"
#import <WebKit/WebKit.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import "SonicJSContext.h"
#import "QuarkToolView.h"
#import "UIView+LFExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 适配 iPhone X
#define IOS11 ([[UIDevice currentDevice].systemVersion intValue] >= 11 ? YES : NO)
#define NAVH 44 //导航栏高度
#define STATUSH [[UIApplication sharedApplication] statusBarFrame].size.height//状态栏高度
#define HEADER (NAVH + STATUSH)
#define IS_IPHONEX (STATUSH > 20)
#define kIPhoneXBottom 34
#define IPHONEX_SafeArea_HEIGHT 734

static const CGFloat kToolViewHeight = 44.0;

@interface QuarkWebViewController ()<NJKWebViewProgressDelegate, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, SonicSessionDelegate, UIGestureRecognizerDelegate, QuarkToolViewDelegate>
@property (nonatomic, strong) UIView *currentWebView;
@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) QuarkToolView *toolView;
@property (nonatomic, assign) JPWebViewType webViewType;
@property (nonatomic, strong) NJKWebViewProgress *uiwebViewProgress;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong)SonicJSContext *sonicContext;

@property (nonatomic, strong) id navPopGestureRecognizerDelegate;
@end

@implementation QuarkWebViewController
#pragma mark - lifecycle
- (instancetype)initWith:(JPWebViewType)webViewType url:(NSString *)url {
    if (self = [super init]) {
        url = url.length ? url : @"http://mc.vip.qq.com/demo/indexv2";
        self.webViewType = webViewType;
        self.url = url;
        self.clickTime = (long long)([[NSDate date]timeIntervalSince1970]*1000);
        switch (self.webViewType) {
            case JPWebViewTypeUIWebView:
            {
                self.currentWebView = self.uiWebView;
                self.uiWebView.delegate = self.uiwebViewProgress;
            }
                break;
            case JPWebViewTypeWKWebView:
            {
                self.currentWebView = self.wkWebView;
                [self.currentWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
                [self.currentWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
            }
                break;
            case JPWebViewTypeSonicWebView:
            {
                self.currentWebView = self.uiWebView;
                self.uiWebView.delegate = self.uiwebViewProgress;
                [[SonicEngine sharedEngine] createSessionWithUrl:self.url withWebDelegate:self];
            }
                break;
            default:
                self.currentWebView = self.uiWebView;
        }
        [self.view addSubview:self.currentWebView];
        [self.view addSubview:self.progressView];
        [self.view addSubview:self.toolView];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.timeoutInterval = 15.0f;
    
    switch (self.webViewType) {
        case JPWebViewTypeUIWebView:
        {
            [self.uiWebView loadRequest:request];
        }
            break;
        case JPWebViewTypeWKWebView:
        {
            [self.wkWebView loadRequest:request];
        }
            break;
        case JPWebViewTypeSonicWebView:
        {
            NSLog(@"索尼克");
            SonicSession* session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
            if (session) {
                [self.uiWebView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:request]];
            }else{
                [self.uiWebView loadRequest:request];
            }
        }
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navPopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.navPopGestureRecognizerDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if (_wkWebView) {
            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (_uiWebView) {
            self.uiWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc
{
    self.sonicContext.owner = nil;
    self.sonicContext = nil;
    self.jscontext = nil;
    self.navPopGestureRecognizerDelegate = nil;
    [[SonicEngine sharedEngine] removeSessionWithWebDelegate:self];
    if (_wkWebView) {
        [self.currentWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.currentWebView removeObserver:self forKeyPath:@"title"];
    }
}

#pragma mark private methods
- (void)LF_goBackAction {
    if (_uiWebView) {
        if ([_uiWebView canGoBack]) {
            [_uiWebView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (_wkWebView) {
        if ([_wkWebView canGoBack]) {
            [_wkWebView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)LF_refreshAction {
    if (_uiWebView) {
        [_uiWebView reload];
    } else if (_wkWebView) {
        [_wkWebView reload];
    }
}

- (void)LF_goForwardAction {
    if (_uiWebView) {
        if ([_uiWebView canGoForward]) {
            [_uiWebView goForward];
        }
    } else if (_wkWebView) {
        if ([_wkWebView canGoForward]) {
            [_wkWebView goForward];
        }
    }
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == _wkWebView) {
            self.toolView.title = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.toolView.title = title;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

#pragma mark - UIWebViewDelegate
// 网页开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载网页");
    self.progressView.hidden = NO;
    [self.view bringSubviewToFront:self.progressView];
}

// 网页加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完成");
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.toolView.title = title;
    self.progressView.hidden = YES;
}

// 网页加载出错的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败");
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.toolView.title = title;
    self.progressView.hidden = YES;
}

// 网页中的每一个请求都会被触发这个方法，返回NO代表不执行这个请求(常用于JS与iOS之间通讯)
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//
//}

#pragma mark - Sonic Session Delegate
/*
 * Call back when Sonic will send request.
 */
- (void)sessionWillRequest:(SonicSession *)session
{
    //This callback can be used to set some information, such as cookie and UA.
}
/*
 * Call back when Sonic require WebView to reload, e.g template changed or error occurred.
 */
- (void)session:(SonicSession *)session requireWebViewReload:(NSURLRequest *)request
{
    [self.uiWebView loadRequest:request];
}

#pragma mark - NJKWebViewProgress
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:NO];
    if (self.progressView.progress == 1) {
        __weak typeof (self)weakSelf = self;
        [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{

        } completion:^(BOOL finished) {
            weakSelf.progressView.hidden = YES;
            
        }];
    }
}

#pragma mark - QuarkToolViewDelegate
- (void)quarkToolView:(QuarkToolView *)toolView backButtonClick:(UIButton *)button {
    [self LF_goBackAction];
}

- (void)quarkToolView:(QuarkToolView *)toolView menuButtonClick:(UIButton *)button {
    
}

- (void)quarkToolView:(QuarkToolView *)toolView titleButtonClick:(UIButton *)button {
    
}

- (void)quarkToolView:(QuarkToolView *)toolView titleButtonDoubleClick:(UIButton *)button {
    
}


#pragma mark - getters and setters
- (UIWebView *)uiWebView {
    if (!_uiWebView) {
        _uiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUSH, kScreenWidth, kScreenHeight - STATUSH - kToolViewHeight)];
        _uiWebView.backgroundColor = [UIColor whiteColor];
        _uiWebView.delegate = self;
        _uiWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    return _uiWebView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUSH, kScreenWidth, kScreenHeight - STATUSH - kToolViewHeight) configuration:self.wkConfig];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
//        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 2)];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor=[UIColor clearColor];
//        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (NJKWebViewProgress *)uiwebViewProgress {
    if (!_uiwebViewProgress) {
        _uiwebViewProgress = [[NJKWebViewProgress alloc] init];
        _uiwebViewProgress.webViewProxyDelegate = self;
        _uiwebViewProgress.progressDelegate = self;
    }
    return _uiwebViewProgress;
}

- (QuarkToolView *)toolView {
    if (!_toolView) {
        _toolView = [[QuarkToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        _toolView.delegate = self;
    }
    return _toolView;
}

@end
