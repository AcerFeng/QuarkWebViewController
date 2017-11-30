//
//  QuarkToolView.h
//  QuarkWebViewController
//
//  Created by lanfeng on 2017/11/28.
//  Copyright © 2017年 lanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuarkToolView;
@protocol QuarkToolViewDelegate <NSObject>
- (void)quarkToolView:(QuarkToolView *)toolView backButtonClick:(UIButton *)button;
- (void)quarkToolView:(QuarkToolView *)toolView titleButtonClick:(UIButton *)button;
- (void)quarkToolView:(QuarkToolView *)toolView titleButtonDoubleClick:(UIButton *)button;
- (void)quarkToolView:(QuarkToolView *)toolView menuButtonClick:(UIButton *)button;
@end

@interface QuarkToolView : UIView
@property (nonatomic, weak) id<QuarkToolViewDelegate> delegate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@end
