#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

//定义一个JSExport protocol
@protocol JSExportTest <JSExport>
//用来保存JS的对象
@property (nonatomic, strong) JSValue *jsValue;

@end

//建一个对象去实现这个协议：

@interface JSProtocolObj : NSObject<JSExportTest>
//添加一个JSManagedValue用来保存JSValue
@property (nonatomic, strong) JSManagedValue *managedValue;

@end

@implementation JSProtocolObj

@synthesize jsValue = _jsValue;
//重写setter方法
- (void)setJsValue:(JSValue *)jsValue
{
    NSLog(@"%@", [jsValue toString]);
    
    _managedValue = [JSManagedValue managedValueWithValue:jsValue];
    
    [[[JSContext currentContext] virtualMachine] addManagedReference:_managedValue withOwner:self];
}

@end

@interface ViewController () <JSExportTest>

@property (nonatomic, strong) JSProtocolObj *obj;
@property (nonatomic, strong) JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建context
    self.context = [[JSContext alloc] init];
    //设置异常处理
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
        NSLog(@"exception:%@",exception);
    };
    //加载JS代码到context中
    [self.context evaluateScript:
     @"function callback(){};function setObj(obj) {this.obj = obj;obj.jsValue=callback;}"];
     //调用JS方法
    self.obj = [[JSProtocolObj alloc] init];
    [self.context[@"setObj"] callWithArguments:@[self.obj]];
}

@end
