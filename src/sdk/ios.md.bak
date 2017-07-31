---
title: iOS SDK
type: sdk
order: 4
---

IOS SDK直接托管在Github上，目前没有托管在Cocospod等类似的第三方平台上（正在进行中...），使用上与Android SDK除了语言上的差别并无二致。

CIBN live云视频解决方案，可帮助用户直接使用经过大规模验证的直播流媒体分发服务,通过CIBN live成熟的P2P技术大幅节省带宽，提供更优质的用户体验。开发者可通过SDK中简洁的接口快速同自有应用集成，实现iOS设备上的视频P2P加速功能。

## 功能

- 直播、点播基本功能+P2P
- 直播时移支持
- 直播HLS P2P原生支持
- 防盗播支持

## 依赖安装

IOS SDK是一个Framework，该framework包含库文件和头文件，在xcode下直接导入项目中即可。

- 首先打开该SDK的[Github][4]，将该项目内容clone到本地
```bash
git clone https://github.com/Vbytes/ios-framework.git /path/to/lib/
```
- 其次，xcode项目中配置依赖CIBNP2P.framework。因为这是一个外部Framework，所以要选择Embed嵌入的方式依赖，xcode 7.3的操作如下：

![Xcode嵌入Framework](http://data1.vbyte.cn/img/xcode-embed-framework.png)

- 然后，Framework底层代码使用GNU标准，所以xcode要配置不要使用libc++11的标准库，如下图红箭头标注的那样。

![Xcode配置C标准](http://data1.vbyte.cn/img/xcode-config-dialect.png)

- 最后xcode编译时可能会遇到bitcode保护问题，target不匹配问题，此时请将 Enable bitcode设置为No，IOS Development Target修改成IOS 6.0，如下图所示：

![Xcode其他配置](http://data1.vbyte.cn/img/xcode-config-other.png)

- 在代码中引入`#import <CIBNP2P/P2PModule.h>`试试，可以的话即成功了。如果不行，确认编译日志里面哪儿出了问题。如果是Framework未找到，尝试再配置Framework search path试试。

## 开始使用

- 首先参考[资源管理][3]在[开发者中心][1]上注册帐号，创建应用，创建应用时要写对包名。然后得到相应的app id,app key与app secret key
- 第二步，P2P模块的应用生命周期管理：在应用启动之初，启动CIBNP2PModule；在应用结束时销毁CIBNP2PModule
```Objective-c
// Example: 程序的入口AppDelegate.m

#import "AppDelegate.h"
#import <CIBNP2P/P2PModule.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // do something other...

    // 初始化P2P
    NSString *appID = @"577cddf55aa77e385435dcff";
    NSString *key = @"ZiMAWNyAdKhjATiK";
    NSString *secret = @"NxSMiy6VUqRel1Cf5OLoCJSjZDQFgaC4";
    [P2PModule init:appID appKey:key appSecretKey:secret];
    
    return YES;
}

// something other function...

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    // 释放P2P模块
    [P2PModule release];
}

@end
```

### 使用直播

直播大家都很熟悉，观众一进来都是直接看到最新的直播内容，本是没有暂停、随机播放（回看）功能。但是应时移回看需求的增长，我们的SDK也提供了时移回看的方式，详细见[API文档][2]。

- 启动一个直播频道的过程如下，其中第2个参数是写死的，必须为UHD；未来多码率支持可能会有HD等更多参数选择:
```Objective-c
// Example: LiveVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do something others as init player and view

    [LiveController load:[channel absoluteString] resolution:@"UHD" listener:^(NSURL *url){
        if (url != nil) {
            self.url = url
            [self.player prepareToPlay:[url absoluteString]];
        }
    }];
}
```

- 退出当前直播播放频道，只需要调用unload即可
```Objective-c
// Example: LiveVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
    // 直播停止的地方
    [LiveController unload];
}
```

### 使用点播

点播与直播最大的不同是点播视频是固定的，包括文件大小固定、内容固定、视频时长固定，有暂停、恢复、随机播放等操作。

- 启动一个点播频道的过程如下:
```Objective-c
// Example: VodVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do something others as init player and view

    [VodController load:[url absoluteString] resolution:@"UHD" startTime:0 listener:^(NSURL *url){
        if (url != nil) {
            self.url = url
            [self.player prepareToPlay:[url absoluteString]];
        }
    }];
}
```
- 暂停和恢复当前点播节目:
```Objective-c
// 在播放器暂停按钮按下时，应调用
[VodController pause];
// 在播放器播放按钮按下时，恢复播放
[VodController resume];
```
- 点播视频支持在不重启播放器的情况下随机位置播放，这在观众滑动进度条时发生，此时播放器会从进度条位置重新加载，而P2P模块能自动感知这样的seek行为，您不用为此做什么。
- 退出当前点播播放频道，只需要调用unload即可
```Objective-c
// Example: VodVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
    // 直播停止的地方
    [VodController unload];
}
```

### 高级功能

更多高级功能诸如开启debug开关、事件监听、直播时移等请参见[IOS版API][2]文档，然后就可以尽情地使用P2P SDK带来的便利功能吧！


## 扩展链接

* **[Github][4]**: SDK的开源代码仓库
* **[API Doc][2]**: 更加详细的API文档，其中包含如直播时移的高级功能使用方法

## 技术支持

感谢阅读本篇文档，希望能帮您尽快上手IOS SDK的用法，再次欢迎您使用CIBN live P2P加速SDK！

*温馨提示*：如果你需要任何帮助，或有任何疑问，请[联系我们](mailto:contact@exatech.cn)。

[1]: http://devcenter.vbyte.cn
[2]: /api/ios/
[3]: /manage/base/
[4]: https://github.com/Vbytes/ios-framework
[5]: https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/IncludingFrameworks.html
