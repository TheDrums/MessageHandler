//
//  YXPlugin.m
//  YXBuilder
//
//  Created by LiYuan on 2017/11/20.
//  Copyright © 2017年 YUSYS. All rights reserved.
//

#import "YXPlugin.h"

static WKWebView *staticWKWebView;
static UIViewController *staticRootViewController;

@implementation YXPlugin

+ (void)setWKWebView:(WKWebView *)wkWebView_ rootViewController:(UIViewController *)rootViewController_ {
    staticWKWebView = wkWebView_;
    staticRootViewController = rootViewController_;
}

+ (void)registPlugin {
    NSDictionary *permission = [messageDic objectForKey:@"permissions"];
    // 只注册context里存在的对象
    for (NSString *plugin in [permission allKeys]) {
        Class cls = NSClassFromString(plugin);
        SEL sel = NSSelectorFromString(@"new");
        YXPlugin *subPlugin = [(id)cls performSelector:sel];
        
        [staticWKWebView.configuration.userContentController addScriptMessageHandler:subPlugin name:[permission valueForKey:plugin]];
    }
}

+ (void)removeScriptMessageHandler {
    NSDictionary *permission = [messageDic objectForKey:@"permissions"];
    for (NSString *value in [permission allValues]) {
        
        [staticWKWebView.configuration.userContentController removeScriptMessageHandlerForName:value];
    }
}

- (WKWebView *)wkWebView {
    return staticWKWebView;
}

- (UIViewController *)rootViewController {
    return staticRootViewController;
}

@end
