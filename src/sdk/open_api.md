---
title: 公共接口
type: sdk
order: 2
---


签名生成规则："AccessKey + '\n\n' + time"组成字符串，SecretKey做秘钥用sha1加密，再用base64加密。
（AccessKey和SecretKey在用户个人中心获取，time是传入的时间戳参数。）

## 开始直播

**http://dev.cibnlive.com/api/v1/live/start**

```
/**
 * 第三方机构获取推流和拉流地址,直播开始前请求
 * 请求地址：http://dev.cibnlive.com/api/v1/live/start
 *
 * @method POST
 *
 * @headers 设置如下http头部
 * Content-Type: application/json; charset=utf-8
 * AccessKey: {Accesskey和Secretkey在用户个人中心获取}
 * Signature: {用户签名}
 * (签名生成规则："AccessKey + '\n\n' + time"组成字符串，SecretKey做秘钥用sha1加密，再用base64加密,
 *  例如：Signature = base64(hmac-sha1(accesskey + "\n\n" + time, SecretKey))
 * )
 *
 * @param {String} appkey 应用的appkey，开发平台账号登录后可创建生成
 *
 * @param {String} cuid 主播的用户id，用于标识主播身份
 *
 * @param {String} time 时间戳
 *
 * @param {String} title 直播的标题
 *
 * @param {Object} user_info 用户信息，包含但不限于以下字段：
 * {
 *  cuid        //用户id
 *  realname    //真实姓名
 *  nickname    //昵称
 *  phone       //电话
 *  address     //居住地址
 *  gender      //性别
 *  identity    //身份证号码
 *  identity_img //身份证照片
 *  avatar      //头像图片
 * }
 *
 * @return {Object} 推拉流地址
 * 地址规则：{应用标识}.{CDN标识}.cibnlive.com/live/{appkey}_{cuid}_{timestamp}_{随机数字}
 * 例如，看东方的返回结果如下:
 * {
 *   "pushAddr": "rtmp://kdf.wslive.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928",
 *   "pullAddr": {
 *       "flv": "http://kdf.wsflv.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928.flv",
 *       "rtmp": "http://kdf.wsrtmp.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928",
 *       "hls": "http://kdf.wshls.cibnlive.com/live/wCOXzowoOsmGe_11125_1486629432113_928.m3u8"
 *   }
 * }
 *
*/
```

## 结束直播

**http://dev.cibnlive.com/api/v1/live/stop**

```
/**
 * 第三方机构直播结束后调用，通知系统修改直播流状态
 * 请求地址：http://dev.cibnlive.com/api/v1/live/stop
 *
 * @method POST
 *
 * @headers 设置如下http头部
 * Content-Type: application/json; charset=utf-8
 * AccessKey: {Accesskey和Secretkey在用户个人中心获取}
 * Signature: {用户签名}
 * (签名生成规则："AccessKey + '\n\n' + time"组成字符串，SecretKey做秘钥用sha1加密，再用base64加密,
 *  例如：Signature = base64(hmac-sha1(accesskey + "\n\n" + time, SecretKey))
 * )
 * 
 * @param {String} appkey 应用的appkey，开发平台账号登录后可创建生成
 *
 * @param {String} cuid 主播的用户id，用于标识主播身份
 *
 * @return {Object} 返回结果
 * {
 *  msg: '停止直播成功'
 * }
 *
 */
 ```







