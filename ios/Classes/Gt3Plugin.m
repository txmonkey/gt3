#import "Gt3Plugin.h"
#import <Flutter/Flutter.h>
#import <GT3Captcha/GT3Captcha.h>


//网站主部署的用于验证注册的接口 (api_1)
//#define api_1 @"https://www.geetest.com/demo/gt/validate-slide"
//网站主部署的二次验证的接口 (api_2)
//#define api_2 @"https://www.geetest.com/demo/gt/validate-slide"

@interface Gt3Plugin () <GT3CaptchaManagerDelegate>

@property (nonatomic, strong) GT3CaptchaButton *captchaButton;
@property (nonatomic) FlutterResult result;
@property (nonatomic) NSString *resultStr;
@property (nonatomic, strong) GT3CaptchaManager *manager;

@end
@implementation Gt3Plugin{
    NSString *api_1;
    NSString *api_2;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"gt3"
            binaryMessenger:[registrar messenger]];
  Gt3Plugin* instance = [[Gt3Plugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"showGeeTest" isEqualToString:call.method]) {
    self.result = result;
    NSDictionary *arguments = [call arguments];
    api_1 = arguments[@"key"];
    api_2 = arguments[@"key"];
    [self.manager registerCaptcha:nil];
    [self.manager startGTCaptchaWithAnimated:FALSE];
    [self.captchaButton startCaptcha];
  } else {
    result(FlutterMethodNotImplemented);
  }
}
- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];

        //debug mode
        //        [captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 260, 44) captchaManager:captchaManager];
    }
    return _captchaButton;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
  if (!error) {
        //处理你的验证结果
        NSLog(@"\ndata333: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        self.result(self.resultStr);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        if (!self.flag) {

        }
    }
    else {
        NSLog(@"\ndata444: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    NSLog(@"result ===>%@",result);
    __block NSMutableString *postResult = [[NSMutableString alloc] init];
    [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [postResult appendFormat:@"%@=%@&",key,obj];
    }];
    self.resultStr = postResult;

}

@end
