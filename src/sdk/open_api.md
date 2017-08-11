---
title: 直播管理
type: sdk
order: 3
---

公共头部信息，请查看相关说明：[安全机制](/sdk/auth.html)


## 开始直播

`POST: http://dev.cibnlive.com/api/v1/live/start`

### 请求参数

| 字段      |类型     |必填 |说明|
|-----------|--------|----|----|
| appkey    | string | Y  |应用的appkey，开放平台账号登录后可创建生成|
| cuid      | string | Y  |主播的用户id，用于标识主播身份|
| time      | int    | Y  |过期时间(unix时间戳)|
| title     | string | Y  |直播的标题|
| user_info | Object | Y  |主播信息，详情见下面|

主播信息需要包含的字段：

| 字段         | 类型  |必填|说明|
|-------------|------|----|----|
| cuid        |string| Y  |主播的用户id，用于标识主播身份|
| realname    |string| Y  |真实姓名|
| identity    |string| Y  |身份证号码|
| identity_img|string| Y  |手持身份证照片|
| avatar      |string| N  |头像图片|
| nickname    |string| N  |昵称|
| phone       |string| Y  |电话|
| address     |string| N  |地址|
| gender      |string| N  |性别|
|alipay_certified|boolean|Y|是否通过支付宝认证|
|alipay_certified_id|string|N|支付宝认证id|

### 返回数据

如果请求成功，将返回json格式的字符串，包含以下字段：

| 字段          | 类型  |必填|说明|
|--------------|------|----|----|
| pushAddr     |string| Y  |推流地址|
| pullAddr     |Object| Y  |拉流地址集合|
| pullAddr.flv |string| Y  |flv格式拉流地址|
| pullAddr.hls |string| Y  |m3u8格式拉流地址|
| pullAddr.rtmp|string| Y  |rtmp格式拉流地址|

例如，看东方的返回结果如下:

```
{
    "pushAddr": "rtmp://kdf.wslive.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928",
    "pullAddr": {
        "flv" : "http://kdf.wsflv.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928.flv",
        "hls" : "http://kdf.wshls.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928/playlist.m3u8",
        "rtmp" : "rtmp://kdf.wsrtmp.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928"
    }
}
```

## 结束直播

`POST: http://dev.cibnlive.com/api/v1/live/stop`

### 请求参数

| 字段      |类型     |必填 |说明|
|-----------|--------|----|----|
| appkey    | string | Y  |应用的appkey，开放平台账号登录后可创建生成|
| cuid      | string | Y  |主播的用户id，用于标识主播身份|

### 返回数据

如果请求成功，将返回json格式的字符串，包含以下字段：

| 字段          | 类型  |必填|说明|
|--------------|------|----|----|
| msg     |string| Y  |结果|
| ret     |int| Y  |0是成功，其他是失败|

返回结果示例：

```
 {
    "ret": 0,
    "msg": "停止直播成功"
 }
 ```

## 直播列表

`GET: http://dev.cibnlive.com/api/v1/live/all`

### 请求参数

| 字段      |类型     |必填 |说明|
|-----------|--------|----|----|
| appkey    | string | N  |应用的appkey，不传默认查询账号下所有应用。|
| page_id   | int    | N  |当前页码，不传默认1|
| page_limit| int    | N  |每页限制个数，不传默认20,最大限制1000|
| status    | string | N  |直播状态：new--新建，start--正在直播，stop--直播结束，不传默认所有状态|
| text      | string | N  |流名称的模糊搜索|

### 返回数据

如果请求成功，将返回json格式的字符串，包含以下字段：

| 字段       | 类型  |必填|说明|
|---------  |------|----|----|
| msg       |string| Y  |结果|
| ret       |int   | Y  |0是成功，其他是失败|
| page_id   |int   | Y  |当前页码|
| page_limit|int   | Y  |每页个数|
| page_total|int   | Y  |结果总数|
| data      |array | Y  |查询结果列表，直播信息体集合|

直播信息体包含的字段：

| 字段          | 类型  |必填|说明|
|---------     |------|----|----|
| anchor       |Object| Y  |主播信息体|
| appkey       |string| Y  |应用的appkey|
| created_time |int   | Y  |创建时间，单位毫秒|
| cuid         |string| Y  |用户id|
| forbidden    |boolean| Y |是否被禁止|
| cause        |string| N  |被禁止原因|
| pushAddr     |string| Y  |推流地址|
| pushAddr     |Object| Y  |拉流地址|
| pushAddr.flv |string| Y  |flv格式的拉流地址|
| pushAddr.hls |string| Y  |m3u8格式的拉流地址|
| pushAddr.rtmp|string| Y  |rtmp格式的拉流地址|
| status       |string| Y  |直播流状态：new--新建，start--正在直播，stop--直播结束|
| streamName   |string| Y  |直播流的名称|
| time         |int   | Y  |过期时间|
| title        |string| Y  |直播名称|
| uid          |string| Y  |账号在平台中的用户id|
| updated_time |int   | Y  |更新时间，单位毫秒|
| _id          |string| Y  |直播流的标识id|

主播信息体包含的字段：

| 字段          | 类型  |必填|说明|
|---------     |------|----|----|
| cuid         |string| Y  |用户id|
| avatar      |string| N  |头像图片|
| nickname    |string| N  |昵称|
| gender      |string| N  |性别|


## 直播禁止/恢复

`POST: http://dev.cibnlive.com/api/v1/live/forbidden`

### 请求参数

| 字段      |类型     |必填 |说明|
|-----------|--------|----|----|
| appkey    | string | Y  |应用的appkey|
| streamName| string | Y  |直播流名称|
| forbidden | boolean | Y  |true为禁播，false为恢复|
| cause     | string | N  |禁播原因|


### 返回数据

如果请求成功，将返回json格式的字符串，包含以下字段：

| 字段       | 类型  |必填|说明|
|---------  |------|----|----|
| msg       |string| Y  |结果|
| ret       |int   | Y  |0是成功，其他是失败|
| data      |array | Y  |执行结果列表|



## 腾讯云混流接口

`POST: http://dev.cibnlive.com/api/v1/live/mix_stream?time={timestamp}&appkey={appkey}`

*该接口必须设置应用的CDN为腾讯云，详细的请求参数请参考[腾讯云文档][1]，这里仅做接口代理，请求的body部分将整个转发至腾讯云（会替换掉相应的app_id）。*
*该接口安全机制跟其他接口一样。*

[1]: https://www.qcloud.com/document/api/267/8832




