//
//  YXMD5Plugin.m
//  YXBuilder
//
//  Created by LiYuan on 2017/11/20.
//  Copyright © 2017年 YUSYS. All rights reserved.
//

#import "YXMD5Plugin.h"
#import "JZYHDictionary.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface YXMD5Plugin ()

@end

@implementation YXMD5Plugin

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //    message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"encrypt"]) {
        [self getEncryptWithParams:message.body];
    }
}

#pragma mark - private method
- (void)getEncryptWithParams:(NSString *)tempStr
{
    if (![tempStr isKindOfClass:[NSString class]]) {
        return;
    }
    
    // 获取位置信息
    NSString *jsStr = [self md5EncryptUpper:tempStr];
    
    // 将结果返回给js
    [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"pluginMD5.encryptCallback('%@')", jsStr] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (NSString *)md5EncryptUpper:(NSString *)text {
    
    if (self == NULL) {
        return NULL;
    }
    const char *cStr = [text UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
