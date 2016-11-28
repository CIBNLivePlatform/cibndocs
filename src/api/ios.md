---
title: iOS API
type: api
order: 2
---

## 概览

#### [interface P2PModule][2]
* **[P2PModule init:appId appkey appSecretKey][3]**
* **[P2PModule release][4]**
* **[P2PModule version][5]**
* **[P2PModule setDelegate: aDelegate][6]**
* **[P2PModule enableDebug][7]**
* **[P2PModule disableDebug][8]**
#### [interface LiveController][9]
* **[LiveController load:channel resolution listener][10]**
* **[LiveController load:channel resolution startTime listener][11]**
* **[LiveController unload][12]**
* **[LiveController getCurrentPlayTime][13]**
#### [interface VodController][14]
* **[VodController load:uri resolution listener][15]**
* **[VodController load:channel resolution startTime listener][16]**
* **[VodController unload][17]**
* **[VodController pause][18]**
* **[VodController resume][19]**
* **[VodController getDuration][20]**

## P2PModule

P2PModule主要管理P2P模块的生命周期，以及运行时的属性。

#### + (int) init:(NSString *)appId appKey:(NSString *)appKey appSecretKey:(NSString *)appSecretKey

此接口传入您在[开发者中心][1]申请的appId，appKey，appSecretKey，来完成P2P模块的载入和初始化。注意这个接口传入的参数与您在[开发者中心][1]上的**应用包名**，以及**app id**、**app key**、**app secret key**不一致的话，播放该应用下的频道的时候，会导致没有权限播放。

#### + (void) release

此接口显式释放P2P模块所占的资源。注意P2P模块底层使用的C++跨平台实现，必须要在程序退出的时候显式调用release才能正确释放。

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
    [P2PModule disableDebug];
    
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

#### + (NSString *) version

该接口获取P2P模块的版本号，返回一个一`v`开头的字符串，开发者可以看需使用。

#### + (void) setDelegate: (id<P2PEventDelegate>) aDelegate

设置事件回调代理，P2PEventDelegate是一个protocol，需要实现onEvent、onError两个函数：
```Objective-c
// 事件代理,上层应用需集成来监听事件状态和错误信息
@protocol P2PEventDelegate <NSObject>

@required
// 事件信息接口
- (void) onEvent: (int)code msg:(NSString *)msg;
// 错误信息接口
- (void) onError: (int)code msg:(NSString *)msg;

@end
```

需要注意的是，第二次绑定Delegate会让覆盖前一次绑定的Delegate。另外，不要在EventHandler处理中有什么耗时操作，如果是耗时的io、阻塞、等待操作，请异步处理！

一个使用P2PEventDelegate的样例如下：
```Objective-c
@interface MyEventHandler : NSObject<P2PEventDelegate>
@end

@implementation MyEventHandler

- (void) onEvent: (int)code msg:(NSString *)msg
{
    NSLog(@"Receive event %d with msg:%@", code, msg);
}

- (void) onError: (int)code msg:(NSString *)msg
{
    NSLog(@"Receive error %d with msg:%@", code, msg);
}
@end

// 在需要的地方绑定事件回调代理
id<P2PEventDelegate> myEventHandler = [[MyEventHandler alloc] init];
[P2PModule setDelegate:myEventHandler];
```

#### + (void) enableDebug

开启调试模式。当您遇到问题时，开启调试信息会输出有用信息，帮助定位问题。若您不好定位解决问题，可借助输出的log联系我们协助。

#### + (void) disableDebug

关闭调试模式。P2P模块默认debug开关是关着的。请注意在发布App时，应关闭调试模式！

## LiveController

直播大家都很熟悉，观众一进来都是直接看到最新的直播内容，本是没有暂停、随机播放（回看）功能。但是应时移回看需求成为一种必须，我们的SDK也提供了时移回看的方式。

#### + (void) load: (NSString *)channel resolution:(NSString *)resoltion listener:(void(^)(NSURL*))listener

该接口载入一个直播频道，频道为channel，分辨率为resolution的源，并使用P2P加速。启动的直播会从最近时间的直播内容开始播放。该函数的最后一个参数是一个回调函数，会返回一个URI，一般使用该URI可直接给播放器打开并播放之。

#### + (void) load: (NSString *)channel resolution:(NSString *)resoltion startTime:(double)startTime listener:(void(^)(NSURL*))listener

与上一个URL不同的是，这个接口多了一个startTime的参数，借助startTime参数，可以实现直播的时移功能，startTime是不能大于当前时间的Unix时间戳。当startTime为0时，功能与上个接口一样。

#### + (void) unload

该接口与load相对应，用于关闭一个频道，应用同一时刻只能播放一个源，所以调用此函数会将上一个您加载的源关闭。该函数应该用在您想让播放器退出的时候。

#### + (void) getCurrentPlayTime

获取当前播放时间。由于直播是无穷无尽的，只能获取它已经播放了多长时间，而此接口能获取到相当于现实时间戳的位置，误差范围10s以内，开发者可看需求使用。

```Objective-c
// Example: LiveVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do something others as init player and view


    // 假设今天是2016/11/10 20:00，要时移回看今天早上8点的节目，早8点的时间戳为1478736000
    [LiveController load:[channel absoluteString] resolution:@"UHD" startTime:1478736000 listener:^(NSURL *url){
        if (url != nil) {
            self.url = url
            [self.player prepareToPlay:[url absoluteString]];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
    // 直播停止的地方
    [LiveController unload];
}
```

## VodController

VodController控制着点播视频的行为模式。

点播与直播最大的不同是点播视频是固定的，包括文件大小固定、内容固定、视频时长固定，有暂停、恢复、随机播放等操作。

点播的随机播放P2P模块会自动感知播放器的随机播放行为，所以SDK并未提供seek(double)的函数。也就是说在观众滑动进度条并释放后，开发者不必显示调用类似seek的函数。

#### + (void) load: (NSString *)channel resolution:(NSString *)resoltion listener:(void(^)(NSURL*))listener

加载一个点播视频，第一个参数可以直接是一个url，也可以预先在[开发者中心][1]里面注册的点播资源频道号；第二个参数现在总是'UHD'，未来可能会考虑对点播转码，提供类似'HD'的参数。它会让该视频从起始位置开始播放，通过最后一个参数的回调函数来获取真正交给播放器的URI。

#### + (void) load: (NSString *)channel resolution:(NSString *)resoltion startTime:(double)startTime listener:(void(^)(NSURL*))listener

功能与上个接口类似。多了一个startTime参数，单位是秒，可以让视频从距离起始startTime处播放。该接口对记忆播放很有用。

#### + (void) unload

与load相对应，用于关闭一个点播视频，应用同一时刻只能播放一个源，所以调用此函数会将上一个您加载的源关闭。该函数应该用在播放器退出播放的时候。

#### + (void) pause

点播视频基本功能之一，在播放器暂停的同时，P2P模块也要暂停。

#### + (void) resume

点播视频基本功能之一，与暂停相对应，恢复被暂停的视频。

#### + (double) getDuration

点播视频基本功能之一，获取点播视频总时长。

```Objective-c
// Example: VodVideoController.m

#import <CIBNP2P/P2PModule.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do something others as init player and view

    // 假设用户上次看到了第10min，这次应从第10min也就是600s处继续观看
    [VodController load:[url absoluteString] resolution:@"UHD" startTime:600 listener:^(NSURL *url){
        if (url != nil) {
            self.url = url
            [self.player prepareToPlay:[url absoluteString]];
        }
    }];
}

- (IBAction)onClickPlay:(id)sender
{
    [self.player play];
    // 被暂停点播恢复播放的地方
    [VodController resume];
    [self.mediaControl refreshMediaControl];
}

- (IBAction)onClickPause:(id)sender
{
    [self.player pause];
    // 点播暂停的地方
    [VodController pause];
    [self.mediaControl refreshMediaControl];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    
    // 点播停止的地方
    [VodController unload];
}
```

## 事件

错误事件会在P2P模块内部发生错误时抛出，正常事件有的是一次性的，有的随时随刻都可能抛出，有的是定时的。详情如下：

### 正常事件

* **INITED**: 标志着P2P模块已经成功初始化，只会抛出一次
* **EXITING**: P2P模块正在退出，只会抛出一次
* **EXITED**: P2P模块已经退出，只会抛出一次
* **LIVE_STARTED**: 标志着直播频道已成功被加载，每次要播放直播时都会抛出
* **LIVE_STOPPED**: 表明直播频道已成功关闭，每次奥关闭直播时都会抛出
* **VOD_STARTED**: 标志着点播视频已成功被加载，每次要播放点播时都会抛出
* **VOD_STOPPED**: 表明点播播视频已成功关闭，每次要关闭点播时都会抛出
* **STREAM_READY**: 表明即将载入频道的数据流已经就绪，将会给播放器数据，在播放器有足够的缓冲后（这取决于播放器自己的设定），就会有画面呈现。事实上，开发者应该在收到此事件时正式播放加载时获取的URI，在此之前可以播放展示广告，此时播放会秒开。不过，这点影响微不足道。
* **BLOCK**: 表明在写数据时遇到了阻塞，这可能会造成播放器的卡顿，也可能并不会造成卡顿
* **DATA_UNBLOCK**: 表明阻塞的数据已经获得，阻塞消失
* **REPORTED**: 表明P2P模块将上传数据，要上传的数据在message里面，是一段json数据

** 注意 **: 与Android不一样，请务必处理这些事件时不要执行耗时的操作，因为它跟ui主线程一样，如果耗时太久，将会阻止数据流的连续载入；如需要耗时的操作，请使用异步处理。

### 异常和错误

* **CONF_UNAVAILABLE**: 配置服务器不可用，将停止载入，不会播放！
* **AUTH_FAILED**: 认证失败，此时您应确保您填入的app id，app key， app secret key都正确
* **CONF_INVALID**: 配置不对，此时，应联系运营人员或者我们，及时修改
* **LIVE_CHANNEL_EMPTY**: 您在载入一个直播频道时没有传频道或者频道为空
* **LIVE_RESOLUTION_INVALID**: 该直播频道不存在这个分辨率，您填写的分辨率不合法或者超出的源本有的清晰度
* **LIVE_NO_SUCH_CHANNEL**: 不存在你想要播放的直播频道，请检查和确认你填写的频道是否正确，是否被下线等
* **BAD_NETWORK**: 网络差，或者程序没有连接上网络，这个错误将会在P2P模块联网失败后抛出
* **UNKNOWN_PACKET**: 收到一个未知类型的包，将忽略
* **INVALID_PACKET**: 收到一个数据不一致的包，将忽略
* **INTERNAL**: 内部错误

[1]: http://devcenter.vbyte.cn
[2]: #p2pmodule
[3]: #int-initnsstring-appid-appkeynsstring-appkey-appsecretkeynsstring-appsecretkey
[4]: #void-release
[5]: #nsstring-version
[6]: #void-setdelegate-id-adelegate
[7]: #void-enabledebug
[8]: #void-disabledebug
[9]: #livecontroller
[10]: #void-load-nsstring-channel-resolutionnsstring-resoltion-listenervoidnsurllistener
[11]: #void-load-nsstring-channel-resolutionnsstring-resoltion-starttimedoublestarttime-listenervoidnsurllistener
[12]: #void-unload
[13]: #void-getcurrentplaytime
[14]: #vodcontroller
[15]: #void-load-nsstring-channel-resolutionnsstring-resoltion-listenervoidnsurllistener_1
[16]: #void-load-nsstring-channel-resolutionnsstring-resoltion-starttimedoublestarttime-listenervoidnsurllistener_1
[17]: #void-unload_1
[18]: #void-pause
[19]: #void-resume
[20]: #double-getduration

