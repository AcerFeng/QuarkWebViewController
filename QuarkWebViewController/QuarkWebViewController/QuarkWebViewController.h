//
//  QuarkWebViewController.h
//  QuarkWebViewController
//
//  Created by lanfeng on 2017/11/27.
//  Copyright © 2017年 lanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef  NS_ENUM(NSInteger , JPWebViewType){
    JPWebViewTypeUIWebView,
    JPWebViewTypeWKWebView,
    JPWebViewTypeSonicWebView
};

@import VasSonic;
@interface QuarkWebViewController : UIViewController
- (instancetype)initWith:(JPWebViewType)webViewType url:(NSString *)url;
@end
