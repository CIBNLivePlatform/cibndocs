---
title: Android API
type: api
order: 1
---

## 概览

#### [class CIBNP2PModule](#cibnp2pmodule)
* **[CIBNP2PModule.create(context, appId, appKey, appSecretKey)](#cibnp2pmodulecreatecontext-appid-appkey-appsecretkey)**
* **[CIBNP2PModule.version()](#cibnp2pmoduleversion)**
* **[CIBNP2PModule.setErrorHandler(errorHandler)](#cibnp2pmoduleseterrorhandlerhandler-errorhandler)**
* **[CIBNP2PModule.setEventHandler(eventHandler)](#cibnp2pmoduleseteventhandlerhandler-eventhandler)**
* **[CIBNP2PModule.enableDebug()](#cibnp2pmoduleenabledebug)**
* **[CIBNP2PModule.disableDebug()](#cibnp2pmoduledisabledebug)**
#### [class LiveController](#livecontroller)
* **[LiveCtroller.load(channel, resolution, listener)](#livectrollerloadstring-channel-string-resolution-onloadedlistener-listener)**
* **[LiveCtroller.load(channel, resolution, startTime, listener)](#livectrollerloadstring-channel-string-resolution-float-starttime-onloadedlistener-listener)**
* **[LiveCtroller.unload()](#livectrollerunload)**
* **[LiveCtroller.getCurrentPlayTime()](#livectrollergetcurrentplaytime)**
#### [class VodController](#vodcontroller)
* **[VodCtroller.load(channel, resolution, listener)](#vodctrollerloadstring-channel-string-resolution-onloadedlistener-listener)**
* **[VodCtroller.load(channel, resolution, startTime, listener)](#vodctrollerloadstring-channel-string-resolution-double-starttime-onloadedlistener-listener)**
* **[VodCtroller.unload()](#vodctrollerunload)**
* **[VodCtroller.pause()](#vodctrollerpause)**
* **[VodCtroller.resume()](#vodctrollerresume)**
* **[VodCtroller.getDuration()](#vodcontrollergetduration)**

## CIBNP2PModule

CIBNP2PModule主要管理P2P模块的生命周期，以及运行时的属性。

#### CIBNP2PModule.create(context, appId, appKey, appSecretKey)

此接口传入应用上下文以及您申请的appId，appKey，appSecretKey，来完成P2P模块的载入和初始化。注意这个接口传入的参数与您在[开发者中心][1]上的**应用包名**，以及**app id**、**app key**、**app secret key**不一致的话，播放该应用下的频道的时候，会导致没有权限播放。

这个函数应在程序一启动就触发，可多次触发。
```java
// Example: MainActivity
// 初始化CIBNP2PModule的相关变量，这是Android sample的样例
final String APP_ID = "577cdcabe0edd1325444c91f";
final String APP_KEY = "G9vjcbxMYZ5ybgxy";
final String APP_SECRET = "xdAEKlyF9XIjDnd9IwMw2b45b4Fq9Nq9";

protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // 初始化P2P模块
    try {
        CIBNP2PModule.create(this.getBaseContext(), APP_ID, APP_KEY, APP_SECRET);
        CIBNP2PModule.disableDebug();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // do others ...
}
```

#### CIBNP2PModule.version();  

该接口获取P2P模块的版本号，返回一个一`v`开头的字符串，开发者可以看需使用。

#### CIBNP2PModule.setErrorHandler(Handler errorHandler)

设置错误处理函数，参数为一Handler。当内部因网络中断、传进去的参数不合法、认证失败等错误时，可以在这里设置这些错误事件的处理函数。具体错误事件可参见本文档所列错误事件。

#### CIBNP2PModule.setEventHandler(Handler eventHandler)

设置正常事件处理函数，参数为一个Handler实例，可与errorHandler是同一个Handler实例。当P2P模块加载成功时、上报数据等事件时，您可以在此设置相应处理。具体事件可参见本文档所列正常事件。

```java
public MyHandler extends Handler {
    public void handleMessage(Message msg) {   
        String instruction = (String) msg.obj;
        switch (msg.what) {   
            case CIBNP2PModule.Event.INITED:  
                Log.d(TAG, instruction);
                break;   
            // ... something 
        }   
        super.handleMessage(msg);   
    }  
}

Handler myHandler = new MyHandler();
CIBNP2PModule.setErrorHandler(myHandler);
CIBNP2PModule.setEventHandler(myHandler);
```

#### CIBNP2PModule.enableDebug()

开启调试模式。当您遇到问题时，开启调试信息会输出有用信息，帮助定位问题。若您不好定位解决问题，可借助输出的log联系我们协助。

#### CIBNP2PModule.disableDebug()

关闭调试模式。P2P模块默认debug开关是关着的。请注意在发布App时，应关闭调试模式！

## LiveController

直播大家都很熟悉，观众一进来都是直接看到最新的直播内容，本是没有暂停、随机播放（回看）功能。但是应时移回看需求成为一种必须，我们的SDK也提供了时移回看的方式。

#### LiveCtroller.load(String channel, String resolution, OnLoadedListener listener)

该接口载入一个直播频道，频道为channel，分辨率为resolution的源，并使用P2P加速。启动的直播会从最近时间的直播内容开始播放。该函数的最后一个参数是一个回调函数，会返回一个URI，一般使用该URI可直接给播放器打开并播放之。

#### LiveCtroller.load(String channel, String resolution, float startTime, OnLoadedListener listener)

与上一个URL不同的是，这个接口多了一个startTime的参数，借助startTime参数，可以实现直播的时移功能，startTime是不能大于当前时间的Unix时间戳。当startTime为0时，功能与上个接口一样。

#### LiveCtroller.unload()

该接口与load相对应，用于关闭一个频道，应用同一时刻只能播放一个源，所以调用此函数会将上一个您加载的源关闭。该函数应该用在您想让播放器退出的时候。

#### LiveCtroller.getCurrentPlayTime()

获取当前播放时间。由于直播是无穷无尽的，只能获取它已经播放了多长时间，而此接口能获取到相当于现实时间戳的位置，误差范围10s以内，开发者可看需求使用。

```java
// Example: Simple LiveVideoActivity
protected void onCreate(Bundle savedInstanceState) {
    try {
        // 假设今天是2016/11/10 20:00，要时移回看今天早上8点的节目，早8点的时间戳为1478736000
        LiveController.getInstance().load("your channel id", "UHD", 1478736000, new OnLoadedListener() {
            @Override
            public void onLoaded(Uri uri) {
                mVideoPath = uri.toString();
                mVideoView.setVideoURI(uri);
                mVideoView.start();
            }
        });
    } catch (Exception e) {
        // 如果打印了此exception，说明load/unload没有成对出现
        e.printStackTrace();
    }

    // do something other...
}

protected void onStop() {
    LiveController.getInstance().unload();
    // do something other...
}
```

## VodController

VodController控制着点播视频的行为模式。

点播与直播最大的不同是点播视频是固定的，包括文件大小固定、内容固定、视频时长固定，有暂停、恢复、随机播放等操作。

点播的随机播放P2P模块会自动感知播放器的随机播放行为，所以SDK并未提供seek(double)的函数。也就是说在观众滑动进度条并释放后，开发者不必显示调用类似seek的函数。

#### VodCtroller.load(String channel, String resolution, OnLoadedListener listener)

加载一个点播视频，第一个参数可以直接是一个url，也可以预先在[开发者中心][1]里面注册的点播资源频道号；第二个参数现在总是'UHD'，未来可能会考虑对点播转码，提供类似'HD'的参数。它会让该视频从起始位置开始播放，通过最后一个参数的回调函数来获取真正交给播放器的URI。

#### VodCtroller.load(String channel, String resolution, double startTime, OnLoadedListener listener)

功能与上个接口类似。多了一个startTime参数，单位是秒，可以让视频从距离起始startTime处播放。该接口对记忆播放很有用。

#### VodCtroller.unload()

与load相对应，用于关闭一个点播视频，应用同一时刻只能播放一个源，所以调用此函数会将上一个您加载的源关闭。该函数应该用在播放器退出播放的时候。

#### VodCtroller.pause()

点播视频基本功能之一，在播放器暂停的同时，P2P模块也要暂停。

#### VodCtroller.resume()

点播视频基本功能之一，与暂停相对应，恢复被暂停的视频。

#### VodController.getDuration()

点播视频基本功能之一，获取点播视频总时长。

```java
// Example: Simple VodVideoActivity
protected void onCreate(Bundle savedInstanceState) {
    try {
        // 假设用户上次看到了第10min，这次应从第10min也就是600s处继续观看
        VodController.getInstance().load("your channel id", "UHD", 600, new OnLoadedListener() {
            @Override
            public void onLoaded(Uri uri) {
                mVideoPath = uri.toString();
                mVideoView.setVideoURI(uri);
                mVideoView.start();
            }
        });
    } catch (Exception e) {
        // 如果打印了此exception，说明load/unload没有成对出现
        e.printStackTrace();
    }

    // do something other...
}

protected void onPause() {
    // 当用户点击暂停按钮时也应触发发调用下面这个函数
    VodController.getInstance().pause();
    // do something other...
}

protected void onResume() {
    // 当用户暂停之后点恢复播放按钮也应触发调用下面这个函数
    VodController.getInstance().resume();
    // do something other...
}

protected void onStop() {
    VodController.getInstance().unload();
    // do something other...
}
```

## 事件

错误事件会在P2P模块内部发生错误时抛出，正常事件有的是一次性的，有的随时随刻都可能抛出，有的是定时的。详情如下：

### 正常事件

* **CIBNP2PModule.Event.INITED**: 标志着P2P模块已经成功初始化，只会抛出一次
* **CIBNP2PModule.Event.EXITING**: P2P模块正在退出，只会抛出一次
* **CIBNP2PModule.Event.EXITED**: P2P模块已经退出，只会抛出一次
* **LiveController.Event.STARTED**: 标志着直播频道已成功被加载，每次要播放直播时都会抛出
* **LiveController.Event.STOPPED**: 表明直播频道已成功关闭，每次奥关闭直播时都会抛出
* **VodController.Event.STARTED**: 标志着点播视频已成功被加载，每次要播放点播时都会抛出
* **VodController.Event.STOPPED**: 表明点播播视频已成功关闭，每次要关闭点播时都会抛出
* **CIBNP2PModule.Event.STREAM_READY**: 表明即将载入频道的数据流已经就绪，将会给播放器数据，在播放器有足够的缓冲后（这取决于播放器自己的设定），就会有画面呈现。事实上，开发者应该在收到此事件时正式播放加载时获取的URI，在此之前可以播放展示广告，此时播放会秒开。不过，这点影响微不足道。
* **CIBNP2PModule.Event.BLOCK**: 表明在写数据时遇到了阻塞，这可能会造成播放器的卡顿，也可能并不会造成卡顿
* **CIBNP2PModule.Event.DATA_UNBLOCK**: 表明阻塞的数据已经获得，阻塞消失
* **CIBNP2PModule.Event.REPORTED**: 表明P2P模块将上传数据，要上传的数据在message里面，是一段json数据

### 异常和错误

* **Error.CONF_UNAVAILABLE**: 配置服务器不可用，将停止载入，不会播放！
* **Error.AUTH_FAILED**: 认证失败，此时您应确保您填入的app id，app key， app secret key都正确
* **Error.CONF_INVALID**: 配置不对，此时，应联系运营人员或者我们，及时修改
* **LiveController.Error.CHANNEL_EMPTY**: 您在载入一个直播频道时没有传频道或者频道为空
* **LiveController.Error.RESOLUTION_INVALID**: 该直播频道不存在这个分辨率，您填写的分辨率不合法或者超出的源本有的清晰度
* **LiveController.Error.NO_SUCH_CHANNEL**: 不存在你想要播放的直播频道，请检查和确认你填写的频道是否正确，是否被下线等
* **Error.BAD_NETWORK**: 网络差，或者程序没有连接上网络，这个错误将会在P2P模块联网失败后抛出
* **Error.UNKNOWN_PACKET**: 收到一个未知类型的包，将忽略
* **Error.INVALID_PACKET**: 收到一个数据不一致的包，将忽略
* **Error.INTERNAL**: 内部错误

[1]: http://devcenter.cibn.cn
