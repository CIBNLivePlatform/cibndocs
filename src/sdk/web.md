---
title: web SDK
type: sdk
order: 5
---

CIBN live云视频直播解决方案，可帮助用户直接使用经过大规模验证的直播流媒体分发服务。用户可通过SDK中简洁的接口快速同自有应用集成，实现web flash播放功能。

## 功能

- 直播、点播基本功能+P2P
- HLS P2P原生支持
- 防盗播支持

## 依赖安装

Flash的SDK其实是一个swf，该swf在网络上可以自由获取。集成是非常简单的，正如像使用js开源插件一样，开发者只需要在as3代码中加载这个swf即可，具体做法参见下面样例代码。

该swf分为直播和点播，它们的地址分别为: 

* **[直播][3]**: http://split.vbyte.cn/sdk/livesdk.swf
* **[点播][4]**: http://split.vbyte.cn/sdk/vodsdk.swf

## 开始使用

- 在使用之前，参考[资源管理][8]在[开发者中心][1]上注册帐号，创建应用，创建应用时要写对域名，flash播放鉴权将依赖此信息，并相应创建频道，以准备好下面的集成。
- 由于我们的SDK扩展自NetStream，支持 Adobe 原生 NetStream 的全部方法，在与使用SDK之前几乎所有的地方都不需要更改

### 使用直播

- 在应用启动之初，加载[livesdk][3]
```actionscript
    var loader:Loader = new Loader();
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSuccess); 
    loader.load(new URLRequest("http://split.vbyte.cn/sdk/livesdk.swf"));
```
- 调用p2pNetStream.play(channelId)播放，channelId为上述步骤中创建的频道ID
```actionscript
    var p2pNetStream:NetStream = liveP2PInstance.stream;
    p2pNetStream.addEventListener(NetStatusEvent.NET_STATUS, onPlayStatus);
    video.attachNetStream(p2pNetStream);    
    p2pNetStream.play(channelId);
```

#### 使用点播

点播与直播最大的不同是点播视频是固定的，包括文件大小固定、视频时长固定，有暂停、恢复、随机播放等操作。

点播的集成方式与直播大同小异，唯一不同的是加载视频的参数不同，其他诸如暂停、恢复、随机播放等操作，都在NetStream中，你之前怎么做的，现在不用作任何更改，只是把您的stream换成我们的p2pNetStream就可以了。

- 在应用启动之初，加载[vodsdk][4]
- 调用p2pNetStream.play(urlArray)播放视频文件。urlArray 为需要使用P2P 播放的文件 URL 列表。
    - 对于切分成多个视频文件的节目，此处传入所有视频文件的url;
    - 对于只包含一个视频文件的节目，只需添加一个 URL 即可。

```actionscript
// Example: Vod Demo
public class cibnVodDemo extends Sprite{ 
        public function cibnVodDemo() { 
            var video:Video = new Video(640, 480); 
            video.smoothing = true; 
            addChild(video); 
            stage.scaleMode = StageScaleMode.NO_SCALE; 
            var loadSuccess:Function = function(e:Event):void { 
                var vodP2PInstance:Object = e.currentTarget.content; 
                // 第2步：加载sdk成功后，播放点播资源
                var p2pNetStream:NetStream = vodP2PInstance.stream;
                p2pNetStream.addEventListener(NetStatusEvent.NET_STATUS, onPlayStatus);
                video.attachNetStream(p2pNetStream);    
                var urlArray:Array = new Array();   
                urlArray.push("http://vod.vbyte.cn/lalala.mp4");
                p2pNetStream.play(urlArray);
            } 
            // 第一步: 加载vodsdk
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSuccess); 
            loader.load(new URLRequest("http://split.vbyte.cn/sdk/vodsdk.swf")); 
        }
        
        // other necessary function...
        protected function onPlayStatus(e:NetStatusEvent):void { 
            // 请在此处进行事件监听处理 
            trace("code: " + e.info.code); 
            if(e.info.code == "NetStream.Pause.Notify") {
                // TODO 
            } 
        } 
    }
} 
```

**注意**: 无论是直播还是点播，由于SDK里面含有防盗播控制，您在Flash builder并不能直接播放，须将编译好的swf放在您在[开发者中心][1]设置的应用的域名下面才能观看。

## 扩展链接

* **[Sample Code][6]**: 一份简单的集成样例项目
* **[Online demo][7]**: 在线可观看的demo页面

## 技术支持

感谢阅读本篇文档，希望能帮您尽快上手Flash SDK的用法，再次欢迎您使用CIBN live P2P加速SDK！

*温馨提示*：如果你需要任何帮助，或有任何疑问，请[联系我们](mailto:contact@exatech.cn)。

[1]: http://devcenter.vbyte.cn
[2]: http://www.vbyte.cn
[3]: http://split.vbyte.cn/sdk/livesdk.swf
[4]: http://split.vbyte.cn/sdk/vodsdk.swf
[5]: /manage/base/
[6]: https://github.com/Vbytes/flash-demo
[7]: http://split.vbyte.cn/demo/demo2.html
