//
//  RootViewController.m
//  YXBuilder
//
//  Created by LiYuan on 2017/11/20.
//  Copyright © 2017年 YUSYS. All rights reserved.
//

#import "RootViewController.h"
#import <WebKit/WebKit.h>
#import "YXPlugin.h"

@interface RootViewController () <WKUIDelegate>

@property (strong, nonatomic)WKWebView *webView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebView];
}

- (NSString *)releaseToPath {
    
    // 移动www路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *basePath = [documentsDirectory stringByAppendingPathComponent:@"www"];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Pandora/www" ofType:@""];
    
    [fileManager removeItemAtPath:basePath error:nil];
    [fileManager copyItemAtPath:resourcePath toPath:basePath error:&error];
    
    return basePath;
}

- (void)initWebView {
    
    NSString *basePath = [self releaseToPath];
    
    NSString *launch_path = [messageDic objectForKey:@"launch_path"];
    NSString *htmlString = [NSString stringWithContentsOfFile:[basePath stringByAppendingPathComponent:launch_path] encoding:NSUTF8StringEncoding error:NULL];
    
    CGRect webViewFrame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    
    // 加载www文件
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    configuration.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    configuration.preferences.minimumFontSize = 30;
    //是否支持JavaScript
    configuration.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:configuration];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:basePath isDirectory:YES]];
    self.webView.UIDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [YXPlugin setWKWebView:self.webView rootViewController:self];
    
    [YXPlugin registPlugin];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [YXPlugin removeScriptMessageHandler];
}
    
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

@end
