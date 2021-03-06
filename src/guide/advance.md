---
title: 高级设置
type: guide
order: 3
---

本篇文档介绍了开发者中心的一些高级设置,包括**事件通知**、**CDN管理**、**绑定域名**


## 事件通知

  一条直播流的状态变化、一个新录制文件的生成、一张新截图文件的生成，这类事件都在平台内部管理，但您的后台服务器可能也同样有获知的需求，这时您可以使用平台的事件通知服务获知这些事件。

### 配置回调地址
  进入`应用详情`，配置该应用的回调地址：
   
  ![配置应用回调](/images/guide/add-callback.png)

### 消息的格式

  通知信息是以 JSON 格式进行组织的，然后放在 HTTP POST 协议体中，注意这里的 POST 格式的 ContentType 是 application/json，而不是 multipart/form-data，所以不要使用 PHP 或者 Java 里读取表单字段的函数来读取信息。
   
### 公共的头信息
  
  | 字段名称    | 类型     | 含义    | 备注   |
  |----------- |---------|-----   |--------|
  | t          | string  | 有效时间 | UNIX时间戳(十进制) |
  | sign       | string  | 安全签名 | MD5(appid+t) |
  | event_type | int     | 事件类型 | 目前可能值为： 0、1、100、200 |
  | stream_id  | string  | 直播码   | 标示事件源于哪一条直播流 |

  * **stream_id（直播码）**
    直播流名称

  * **t（过期时间）**
    来自平台的消息通知的默认过期时间是10分钟，如果一条通知消息中的 t 值所指定的时间已经过期，则可以判定这条通知无效，进而可以防止网络重放攻击。t 的格式为十进制UNIX时间戳，即从1970年1月1日（UTC/GMT的午夜）开始所经过的秒数。

  * **sign（安全签名）**
    sign = MD5(appid + t) ：平台把加密appid 和 t 进行字符串拼接后，通过MD5计算得出sign值，并将其放在通知消息里，您的后台服务器在收到通知消息后可以根据同样的算法确认sign是否正确，进而确认消息是否确实来自平台。
    这里的appid，您可以在管理后台的应用详情页面找到，如下图所示：

    ![应用详情](/images/guide/app-sample1.png)

  * **event_type（通知类型）**
    目前平台支持三种消息类型的通知：0 — 断流； 1 — 推流；100 — 新的录制文件已生成；200 — 新的截图文件已生成。

### 各类型消息体

  **(1)推流 (0)断流**

  event_type = 0 代表断流，event_type = 1 代表推流，同时消息体会额外包含如下信息：

  | 字段名称       | 类型     | 含义         | 备注 | 是否必须 |
  |---------------|---------|--------------|-----|---------|
  | appname       | string  | 应用名称      |     | Y  |
  | domain        | string  | 推流域名      |     | Y  |
  | update_time   | int     | 消息产生的时间 | 单位s | Y |
  | user_ip       | string  | 用户推流ip    |Client_ip| Y|
  | errcode       | string  | 断流错误码     |     | N |
  | errmsg        | string  | 断流错误信息   |      | N |
  | stream_param  | string  | 推流url参数   |       | Y |
  | push_duration | string  | 推流时长      | 单位ms | Y |

  ** 推流断流错误码 **

  | 错误码 | 错误描述               | 错误原因     |
  |-------|-----------------------|-------------|
  | 1     | recv rtmp deleteStream | 主播端主动断流 |
  | 2     | recv rtmp closeStream | 主播端主动断流 |
  | 3     | recv() return 0       | 主播端主动断开TCP连接 |
  | 4     | recv() return error   | 主播端TCP连接异常 |
  | 7     | rtmp message large than 1M | 收到流数据异常 |
  | 18    | push url maybe invalid | 推流鉴权失败，服务端禁止推流 |
  | 19    | 3rdparty auth failed  | 第三方鉴权失败，服务端禁止推流|
  | 其他错误码 | 直播服务内部异常     | [联系管理人员](mailto:cibnlive@cri.cn)|

  **(100)新录制文件**
  event_type = 100 代表有新的录制文件生成，同时消息体会额外包含如下信息：

  | 字段名称      | 含义     | 类型      | 备注           | 是否必须 |
  |--------------|-----     |---------|-----------------|----------|
  | download_url | 下载地址   | string | 点播视频的下载地址 | Y |
  | file_size    | 文件大小   | string | 点播视频的下载地址 | Y |
  | start_time   | 分片开始时间戳   | string | 开始时间（unix时间戳，由于I帧干扰，暂时不能精确到秒级） | Y |
  | end_time     | 分片结束时间戳   | string | 结束时间（unix时间戳，由于I帧干扰，暂时不能精确到秒级） | Y |
  | file_id      | file_id    | string     |            | Y |
  | file_format  | file_format | string    | flv, hls, mp4 | Y |
  | duration     | 推流时长     | int       |            | Y |
  | stream_param | 推流url参数  | string    |            | Y |

  **(200)新截图文件**
  event_type = 200 代表有新的截图图片生成，同时消息体会额外包含如下信息：

  | 字段名称      | 含义      | 类型    | 备注           | 是否必须 |
  |--------------|-----     |---------|-----------------|----------|
  | pic_url      | 图片地址   | string | 不带域名的路径 | Y |
  | create_time  | 截图时间戳 | int    | 截图时间戳（unix时间戳，由于I帧干扰，暂时不能精确到秒级） | Y |
  | pic_full_url | 截图全路径 | string | 需要带上域名 | Y |

### 通知可靠性
  很多客户会担心消息丢了怎么办，比如客户的服务器宕机了一下会儿，消息会不会丢失呢？
  腾讯云后台目前的消息可靠性保证机制是基于**简单重传**实现的，即：`如果一条通知消息没有成功发送到您指定的回调URL，平台会反复重试3次`。

  那怎么确认消息是已经送达您的服务器了呢？这里是需要您的协助的：**当您的服务器成功收到一条http事件通知消息时**，请回复：
    ```
     // 在收到消息通知的http请求里返回错误码 0  以代表您已经成功收到了消息，从而避免平台反复重复通知
     { "code":0 }
    ```
  代表：“嗯，我（客户服务器）已经你的通知了，请（平台）不要再不断地发消息给我”。

<br>

## CDN管理
  
   CDN供应商提供直播流的处理和分发、直播转录播、录播文件存储和统计信息等功能，直接影响着您应用的流畅度和稳定性，请谨慎选择。
   该功能目前没有开放给用户，可联系管理员进行设置与修改。

<br>

## 绑定域名
   
   应用的域名前缀在创建应用时自主填写，填写后会生成相应的推拉流域名，创建完成后联系管理员使其生效。
   
   ![绑定域名](/images/guide/domain.png)




[1]: http://dev.cibnlive.com

