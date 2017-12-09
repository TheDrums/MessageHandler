//
//  YXPlugin.h
//  YXBuilder
//
//  Created by LiYuan on 2017/11/20.
//  Copyright © 2017年 YUSYS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface YXPlugin : NSObject <WKScriptMessageHandler>

- (WKWebView *)wkWebView;
- (UIViewController *)rootViewController;

+ (void)setWKWebView:(WKWebView *)wkWebView rootViewController:(UIViewController *)rootViewController;
+ (void)registPlugin;
+ (void)removeScriptMessageHandler;

@end
